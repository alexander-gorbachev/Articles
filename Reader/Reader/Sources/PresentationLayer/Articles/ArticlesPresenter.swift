import Foundation

final class ArticlesPresenterImpl: ArticlesPresenter {
    weak var view: ArticlesView?
    var interactor: ArticlesInteractor?
    var router: ArticlesRouter?
    
    func didLoadView() {
        obtainInitialData()
        subscribeOnUpdates()
    }
    
    func didSelectPreferences() {
        router?.showPreferences(output: self)
    }
    
    func didSelectChangeAppearance() {
        canShowDetails.toggle()
        
        viewModels.forEach { $0.canShowDetails = canShowDetails }
        
        view?.reloadAppearance()
    }
    
    func didSelectReload() {
        obtainInitialData()
    }
    
    func didSelect(article viewModel: ArticleViewModel) {
        guard let sourceItems = articles.first(where: { $0.source == viewModel.source })?.items,
               let article = sourceItems.first(where: { $0.id == viewModel.id }) else {
            return
        }
        
        interactor?.markArticleIsViewed(article: viewModel.id, from: viewModel.source)
        viewModel.isViewed = interactor?.isArticleViewed(article: article.id, from: viewModel.source) ?? false
        view?.update(article: viewModel)
        
        router?.showArticle(url: article.url)
    }
    
    private var articles = [Articles]()
    private var canShowDetails = false
    private var viewModels = [ArticleViewModel]()
}

extension ArticlesPresenterImpl: PreferencesPresenterOutput {
    func preferencesArticlesDidChanged() {
        obtainData { }
    }
}

private extension ArticlesPresenterImpl {
    func obtainInitialData() {
        view?.showLoading(true)
        view?.showTitle("Loading..")
        
        view?.setPreferences(enabled: false)
        view?.setChangeAppearance(enabled: false)
        
        obtainData { [weak self] in
            guard let self = self else { return }
            
            self.view?.showLoading(false)
            self.view?.setPreferences(enabled: true)
            self.view?.setChangeAppearance(enabled: !self.viewModels.isEmpty)
        }
    }
    
    func obtainData(handler: @escaping () -> Void) {
        interactor?.obtainArticles() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let articles):
                let viewModels = articles
                    .reduce([ArticleViewModel]()) { result, article in
                        result + article.items.map { self.buildViewModels(for: $0, source: article.source) }
                    }
                    .sorted(by: { $0.createdDate > $1.createdDate })
                
                self.viewModels = viewModels
                self.articles = articles
                self.view?.showArticles(viewModels)
                self.view?.showTitle("\(viewModels.count) articles")
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
                self.view?.showTitle("🙈")
            }
            
            handler()
        }
    }
    
    func buildViewModels(for model: ArcticleModel, source: ArticleSource) -> ArticleViewModel {
        return ArticleViewModel(
            model: model,
            source: source,
            isViewed: interactor?.isArticleViewed(article: model.id, from: source) ?? false,
            canShowDetails: canShowDetails
        )
    }
    
    func subscribeOnUpdates() {
        interactor?.subscribeOnUpdates { [weak self] in
            self?.obtainData { }
        }
    }
}
