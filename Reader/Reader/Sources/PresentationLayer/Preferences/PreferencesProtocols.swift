import UIKit

protocol PreferencesPresenterInput: AnyObject {
    func didLoadView()
    
    func didChange(value: Bool, at indexPath: IndexPath)
    func didCloseEvent()
}

protocol PreferencesPresenterOutput: AnyObject {
    func preferencesArticlesDidChanged()
}

protocol PreferencesInteractor: AnyObject {
    func obtainEnabledSources() -> [ArticleSource]
    func set(enabled: Bool, for source: ArticleSource)
    
    func obtainUpdatesPeriod() -> ArticlesUpdatePeriod
    func set(updatesPeriod period: ArticlesUpdatePeriod)
}

protocol PreferencesRouter: AnyObject {
    var finish: (() -> Void)? { get set }
}

protocol PreferencesViewInput: AnyObject {
    func show(title: String)
    func show(sections: [PreferencesPresenterSection])
    func update(section: PreferencesPresenterSection)
}
