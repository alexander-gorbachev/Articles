import Foundation

enum DependencyLifetime {
    case transient, once
}

final class Dependency {
    class func register<T: Any>(_ type: T.Type, lifetime: DependencyLifetime, constructor: @escaping () -> T) {
        let dependencyKey = String(reflecting: T.self)
        shared.register(by: dependencyKey, lifetime: lifetime, constructor: constructor)
    }
    
    class func resolve<T: Any>(_ type: T.Type = T.self) -> T {
        let dependencyKey = String(reflecting: T.self)
        let instance: T? = shared.resolve(by: dependencyKey)
        assert(instance != nil, "Resolved object is not kind of type \(dependencyKey)")
        return instance!
    }
    
    private static let shared = Dependency()
    private var dependencies = [String: Any]()
}

private extension Dependency {
    func register<T>(by key: String, lifetime: DependencyLifetime, constructor: @escaping () -> T) {
        let resolver: () -> T
        switch lifetime {
        case .transient:
            resolver = constructor
        case .once:
            var onceInstance: T?
            resolver = {
                guard let instance = onceInstance else {
                    let constructorInstance = constructor()
                    onceInstance = constructorInstance
                    return constructorInstance
                }
                return instance
            }
        }
        dependencies[key] = resolver
    }
    
    func resolve<T>(by key: String) -> T? {
        guard let resolver = dependencies[key] as? () -> T else {
            assert(false, "No registration for dependency key — \(key)")
            return nil
        }
        return resolver()
    }
}
