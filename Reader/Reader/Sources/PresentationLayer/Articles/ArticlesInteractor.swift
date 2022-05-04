import Foundation

final class ArticlesInteractorImpl: ArticlesInteractor {
    init(
        articlesFacade: ArticlesFacade,
        viewsStorage: ArticleViewsStorage,
        updateService: ArticleUpdateServiceObservable
    ) {
        self.articlesFacade = articlesFacade
        self.viewsStorage = viewsStorage
        self.updateService = updateService
    }
    
    func obtainArticles(handler: @escaping (Result<[Articles], Error>) -> Void) {
        articlesFacade.obtainArticles(handler: handler)
    }
    
    func isArticleViewed(article id: String, from source: ArticleSource) -> Bool {
        viewsStorage.viewedArticlesIds(for: source).contains(id)
    }
    
    func markArticleIsViewed(article id: String, from source: ArticleSource) {
        viewsStorage.setIsViewed(articleId: id, from: source)
    }
    
    func subscribeOnUpdates(handler: @escaping () -> Void) {
        updateServiceObservable = updateService.subscribe(handler: handler)
    }
        
    private let articlesFacade: ArticlesFacade
    private let viewsStorage: ArticleViewsStorage
    private let updateService: ArticleUpdateServiceObservable
    private var updateServiceObservable: ArticleUpdateServiceObserver?
}
