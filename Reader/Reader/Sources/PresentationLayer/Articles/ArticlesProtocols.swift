import Foundation

protocol ArticlesPresenter: AnyObject {
    func didLoadView()
    
    func didSelectPreferences()
    func didSelectChangeAppearance()
    func didSelectReload()
    func didSelect(article: ArticleViewModel)
}

protocol ArticlesInteractor: AnyObject {
    func obtainArticles(handler: @escaping (Result<[Articles], Error>) -> Void)
    
    func subscribeOnUpdates(handler: @escaping () -> Void)

    func isArticleViewed(article id: String, from source: ArticleSource) -> Bool
    func markArticleIsViewed(article id: String, from source: ArticleSource)
}

protocol ArticlesRouter: AnyObject {
    func showArticle(url: URL)
    func showPreferences(output: PreferencesPresenterOutput)
}

protocol ArticlesView: AnyObject {
    func showTitle(_ title: String)
    func showArticles(_ articles: [ArticleViewModel])
    func showLoading(_ isLoading: Bool)
    func showError(_ error: String)
    
    func setPreferences(enabled isEnabled: Bool)
    func setChangeAppearance(enabled isEnabled: Bool)
    
    func update(article: ArticleViewModel)
    
    func reloadAppearance()
}
