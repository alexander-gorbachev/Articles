import UIKit
import SafariServices

final class ArticlesRouterImpl: ArticlesRouter {
    weak var transition: UIViewController?
    
    func showArticle(url: URL) {
        let viewController = SFSafariViewController(url: url)
        
        transition?.present(viewController, animated: true, completion: nil)
    }
    
    func showPreferences(output: PreferencesPresenterOutput) {
        let moduleInput = PreferencesModuleContainer.Input(output: output)
        let container = PreferencesModuleContainer.assemble(input: moduleInput)
        
        let router = container.router
        
        let viewControllerToPresent = NavigationController(rootViewController: container.viewController)
        
        if let sheetPresentationController = viewControllerToPresent.sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
        }
        
        transition?.present(viewControllerToPresent, animated: true, completion: nil)
        
        router?.finish = { [weak viewControllerToPresent] in
            viewControllerToPresent?.dismiss(animated: true)
        }
    }
}
