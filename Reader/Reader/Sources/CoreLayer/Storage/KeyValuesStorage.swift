import Foundation

protocol KeyValueStoring {
    func get<T>(by key: String) -> T?
    func set(value: Any?, by key: String)
    func removeValue(by key: String)
}

final class SharedStorage: KeyValueStoring {
    static let `default`: KeyValueStoring = SharedStorage()
    
    func get<T>(by key: String) -> T? {
        return storage.value(forKey: key) as? T
    }
    
    func set(value: Any?, by key: String) {
        storage.set(value, forKey: key)
        storage.synchronize()
    }
    
    func removeValue(by key: String) {
        storage.removeObject(forKey: key)
        storage.synchronize()
    }
    
    private lazy var storage = UserDefaults.standard
}
