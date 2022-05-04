import Foundation

final class PreferencesPresenterImpl: PreferencesPresenterInput {
    weak var view: PreferencesViewInput?
    weak var output: PreferencesPresenterOutput?
    var interactor: PreferencesInteractor?
    var router: PreferencesRouter?
    
    func didLoadView() {
        let enabledSources = interactor?.obtainEnabledSources() ?? []
        let articleViewModels = ArticleSource.allCases.map { PreferencesArticleViewModel(source: $0, isEnabled: enabledSources.contains($0)) }
        let articlesUpdateViewModels = ArticlesUpdatePeriod.allCases.map {
            PreferencesArticlesUpdatePeriodViewModel(
                period: $0,
                isEnabled: interactor?.obtainUpdatesPeriod() == $0
            )
        }
        sections = [
            .articles(viewModels: articleViewModels),
            .articlesUpdates(viewModels: articlesUpdateViewModels)
        ]
        
        view?.show(title: "Preferences")
        view?.show(sections: sections)
    }
    
    func didChange(value: Bool, at indexPath: IndexPath) {
        let section = sections[indexPath.section]
        
        switch section {
        case .articles(let viewModels):
            let viewModel = viewModels[indexPath.item]
            viewModel.value = value
            
            interactor?.set(enabled: value, for: viewModel.source)
            output?.preferencesArticlesDidChanged()
        case .articlesUpdates(let viewModels):
            viewModels.forEach { $0.value = false }
            
            let viewModel = viewModels[indexPath.item]
            viewModel.value = value
            
            interactor?.set(updatesPeriod: viewModel.period)
            view?.update(section: section)
        }
    }
    
    func didCloseEvent() {
        router?.finish?()
    }
    
    private var sections = [Section]()
}

private extension PreferencesPresenterImpl {
    enum Section: PreferencesPresenterSection, Equatable {
        case articles(viewModels: [PreferencesArticleViewModel])
        case articlesUpdates(viewModels: [PreferencesArticlesUpdatePeriodViewModel])
        
        var id: Int {
            switch self {
            case .articles: return 0
            case .articlesUpdates: return 1
            }
        }
    
        var title: String {
            switch self {
            case .articles: return "Articles"
            case .articlesUpdates: return "Update articles period"
            }
        }
        
        var subtitle: String? {
            switch self {
            case .articles: return "You can see chosen articles on articles screen"
            case .articlesUpdates: return "Articles will be updated at the selected period"
            }
        }
        
        var rows: [PreferencesPresenterRow] {
            switch self {
            case .articles(let viewModels): return viewModels
            case .articlesUpdates(let viewModels): return viewModels
            }
        }
    }
}

private final class PreferencesArticleViewModel: PreferencesPresenterRow, Equatable {
    let title: String
    let style: PreferencesPresenterRowStyle = .switcher
    var value: Any?
    
    let source: ArticleSource
    
    init(source: ArticleSource, isEnabled: Bool) {
        self.source = source
        self.title = source.rawValue.capitalized
        self.value = isEnabled
    }
    
    static func == (lhs: PreferencesArticleViewModel, rhs: PreferencesArticleViewModel) -> Bool {
        lhs.source == rhs.source
    }
}

private final class PreferencesArticlesUpdatePeriodViewModel: PreferencesPresenterRow, Equatable {
    let title: String
    let style: PreferencesPresenterRowStyle = .checkmark
    var value: Any?
    
    let period: ArticlesUpdatePeriod
    
    init(period: ArticlesUpdatePeriod, isEnabled: Bool) {
        switch period {
        case .never:
            self.title = "Never"
        case .minute:
            self.title = "Every minute"
        case .fiveMinutes:
            self.title = "Every 5 minutes"
        case .tenMinutes:
            self.title = "Every 10 minutes"
        }
        self.value = isEnabled
        self.period = period
    }
    
    static func == (lhs: PreferencesArticlesUpdatePeriodViewModel, rhs: PreferencesArticlesUpdatePeriodViewModel) -> Bool {
        lhs.period == rhs.period
    }
}
