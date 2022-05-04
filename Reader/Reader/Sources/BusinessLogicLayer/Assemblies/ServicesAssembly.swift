import Storage
import HTTPClient

struct ServicesAssembly {
    func assembly() {
        assemblyDefaultServices()
        assemblyArticleServices()
        assemblySourceServices()
    }
}

private extension ServicesAssembly {
    func assemblyDefaultServices() {
        Dependency.register(CoreDataStorage.self, lifetime: .once) {
            let containerURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            let storeURL = containerURL.appendingPathComponent("reader.sqlite")
            return CoreDataStorage(model: "ReaderDataModel", url: storeURL)
        }
        Dependency.register(HTTPClient.self, lifetime: .once) { HTTPClientImpl() }
        Dependency.register(KeyValueStoring.self, lifetime: .once, constructor: { SharedStorage.default })
    }
    
    func assemblyArticleServices() {
        Dependency.register(ArticlesStorageService.self, lifetime: .once) { ArticlesStorageServiceImpl(storage: Dependency.resolve()) }
        Dependency.register(ArticleSourcesStorage.self, lifetime: .once) { ArticleSourcesStorageImpl(storage: Dependency.resolve()) }
        Dependency.register(ArticleViewsStorage.self, lifetime: .once) { ArticleViewsStorageImpl(storage: Dependency.resolve()) }
        Dependency.register(ArticleUpdatePeriodStorage.self, lifetime: .once) { ArticleUpdatePeriodStorageImpl(storage: Dependency.resolve()) }
        
        Dependency.register(ArticleUpdateServiceImpl.self, lifetime: .once, constructor: { ArticleUpdateServiceImpl() })
        Dependency.register(ArticleUpdateServiceObservable.self, lifetime: .transient, constructor: { Dependency.resolve() as ArticleUpdateServiceImpl })
        Dependency.register(ArticleUpdateService.self, lifetime: .transient, constructor: { Dependency.resolve() as ArticleUpdateServiceImpl })
    }
    
    func assemblySourceServices() {
        guard let APIKey = Bundle.main.infoDictionary?["NewsAPIKey"] as? String,
              !APIKey.isEmpty else {
            fatalError("Can't fine APIKey value in Info.plist")
        }
        Dependency.register(NewsAPIService.self, lifetime: .transient, constructor: {
            NewsAPIServiceImpl(HTTPClient: Dependency.resolve(), APIKey: APIKey)
        })
    }
}
