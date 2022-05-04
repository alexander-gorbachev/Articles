import UIKit

final class ArticlesModuleContainer {
    private(set) var viewController: UIViewController!
        
    static func assemble() -> ArticlesModuleContainer {
        let container = ArticlesModuleContainer()
        container.configure()
        
        return container
    }
    
    private init() { }
    private func configure() {
        let viewController: ArticlesViewController = UIStoryboard.instantiateInitialViewController()
        let presenter = ArticlesPresenterImpl()
        let interactor = ArticlesInteractorImpl(
            articlesFacade: Dependency.resolve(),
            viewsStorage: Dependency.resolve(),
            updateService: Dependency.resolve()
        )
        let router = ArticlesRouterImpl()
        
        router.transition = viewController
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        self.viewController = viewController
    }
}
