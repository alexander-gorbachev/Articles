import Foundation

final class PreferencesInteractorImpl: PreferencesInteractor {
    init(
        sourceStorage: ArticleSourcesStorage,
        updatePeriodStorage: ArticleUpdatePeriodStorage,
        viewsStorage: ArticleViewsStorage
    ) {
        self.sourceStorage = sourceStorage
        self.updatePeriodStorage = updatePeriodStorage
        self.viewsStorage = viewsStorage
    }
    
    func obtainEnabledSources() -> [ArticleSource] {
        sourceStorage.getEnabledSources()
    }
    
    func set(enabled: Bool, for source: ArticleSource) {
        sourceStorage.set(source: source, enabled: enabled)
        
        if !enabled {
            viewsStorage.removeArticlesIds(for: source)
        }
    }
    
    func obtainUpdatesPeriod() -> ArticlesUpdatePeriod {
        return updatePeriodStorage.getCurrentPeriod()
    }
    
    func set(updatesPeriod period: ArticlesUpdatePeriod) {
        updatePeriodStorage.set(period: period)
    }
    
    private let sourceStorage: ArticleSourcesStorage
    private let updatePeriodStorage: ArticleUpdatePeriodStorage
    private let viewsStorage: ArticleViewsStorage
}
