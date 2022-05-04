import UIKit

extension UIStoryboard {
    static func instantiateInitialViewController<T: UIViewController>(storyboard name: String = String(describing: T.self), bundle: Bundle? = nil) -> T {
        let resourceBundle = bundle ?? Bundle(for: T.self)
        return UIStoryboard(name: name, bundle: resourceBundle).instantiateInitialViewController() as! T
    }
}
