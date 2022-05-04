import UIKit

extension UIView {
    func hide() {
        if !isHidden {
            isHidden = true
            alpha = 0.0
        }
    }
    
    func show() {
        if isHidden {
            isHidden = false
            alpha = 1.0
        }
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String { String(describing: Self.self) }
}

extension UICollectionReusableView {
    static var reuseIdentifier: String { String(describing: Self.self) }
}
