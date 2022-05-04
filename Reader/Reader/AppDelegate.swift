import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationAssembly.assembly()
        
        let window = UIWindow(frame: UIScreen.main.bounds)

        let container = ArticlesModuleContainer.assemble()
        window.rootViewController = NavigationController(rootViewController: container.viewController)
                
        self.window = window
        self.window?.makeKeyAndVisible()
        return true
    }
}
