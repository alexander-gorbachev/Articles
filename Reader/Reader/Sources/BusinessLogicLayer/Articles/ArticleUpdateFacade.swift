import Foundation

protocol ArticleUpdateFacade: ArticleUpdatePeriodStorage, ArticleUpdateService, ArticleUpdateServiceObservable { }

final class ArticleUpdateFacadeImpl: ArticleUpdateFacade {
    init(
        storage: ArticleUpdatePeriodStorage,
        updateService: ArticleUpdateService,
        updateServiceObservable: ArticleUpdateServiceObservable
    ) {
        self.storage = storage
        self.updateService = updateService
        self.updateServiceObservable = updateServiceObservable
        
        updateService.set(period: storage.getCurrentPeriod())
    }
    
    func subscribe(handler: @escaping () -> Void) -> ArticleUpdateServiceObserver {
        return updateServiceObservable.subscribe(handler: handler)
    }
    
    func set(period: ArticlesUpdatePeriod) {
        storage.set(period: period)
        
        updateService.set(period: period)
    }
    
    func getCurrentPeriod() -> ArticlesUpdatePeriod {
        storage.getCurrentPeriod()
    }
    
    private let storage: ArticleUpdatePeriodStorage
    private let updateService: ArticleUpdateService
    private let updateServiceObservable: ArticleUpdateServiceObservable
}
