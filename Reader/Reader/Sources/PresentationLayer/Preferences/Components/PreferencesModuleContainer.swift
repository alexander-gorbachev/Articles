import UIKit

final class PreferencesModuleContainer {
    struct Input {
        let output: PreferencesPresenterOutput
    }
    
    private(set) var viewController: UIViewController!
    private(set) var router: PreferencesRouter!
        
    static func assemble(input: Input) -> PreferencesModuleContainer {
        let container = PreferencesModuleContainer()
        container.configure(with: input)
        
        return container
    }
    
    private init() { }
    private func configure(with input: Input) {
        let viewController: PreferencesViewController = UIStoryboard.instantiateInitialViewController()
        let presenter = PreferencesPresenterImpl()
        let interactor = PreferencesInteractorImpl(
            sourceStorage: Dependency.resolve(),
            updatePeriodStorage: Dependency.resolve(),
            viewsStorage: Dependency.resolve()
        )
        let router = PreferencesRouterImpl()
                
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.output = input.output
        
        self.viewController = viewController
        self.router = router
    }
}
