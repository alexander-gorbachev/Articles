import CoreData

public final class CoreDataStorage {
    public init(model: String, url: URL) {
        container = NSPersistentContainer(name: model)

        let description = NSPersistentStoreDescription(url: url)
        description.type = NSSQLiteStoreType
        description.shouldInferMappingModelAutomatically = true
        description.shouldMigrateStoreAutomatically = true

        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { [container] _, error in
            if error != nil {
                fatalError(error.debugDescription)
            }
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
        backgroudContext = container.newBackgroundContext()
    }
    
    private let container: NSPersistentContainer
    private let backgroudContext: NSManagedObjectContext
}

extension CoreDataStorage: Storage {
    public func delete<T>(entity: T) {
        let entity = entity as! NSManagedObject
        backgroudContext.delete(backgroudContext.object(with: entity.objectID))
        try! backgroudContext.save()
    }

    public func create<T>() -> T {
        let type = T.self as! NSManagedObject.Type
        return NSEntityDescription.insertNewObject(forEntityName: type.entityName, into: backgroudContext) as! T
    }

    public func get<T>() -> [T] {
        let type = T.self as! NSManagedObject.Type
        let request = NSFetchRequest<NSManagedObject>(entityName: type.entityName)
        return try! container.viewContext.fetch(request) as! [T]
    }

    public func add<T>(entity: T) {
        try! backgroudContext.save()
    }

    public func save<T>(entity: T) {
        let entity = entity as! NSManagedObject
        var context = entity.managedObjectContext
        repeat {
            try? context?.save()
            context = context?.parent
        } while context != nil
    }
}


private extension NSManagedObject {
    class var entityName: String { String(describing: self) }
}

extension NSManagedObject: StorageEntity { }
