import UIKit

extension UIImage {
    class func roundedColoredImage(
        color: UIColor,
        diameter: CGFloat,
        alpha: CGFloat? = nil
    ) -> UIImage? {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fillEllipse(in: CGRect(x: 0.0, y: 0.0, width: diameter, height: diameter))
        context?.setBlendMode(.multiply)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let alpha = alpha, let currentImage = image {
            UIGraphicsBeginImageContextWithOptions(currentImage.size, false, currentImage.scale)
            currentImage.draw(at: CGPoint.zero, blendMode: .normal, alpha: alpha)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image?.stretchableImage(withLeftCapWidth: Int(diameter / 2.0), topCapHeight: Int(diameter / 2.0))
    }
}
