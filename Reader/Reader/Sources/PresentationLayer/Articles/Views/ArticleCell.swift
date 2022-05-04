import UIKit
import Nuke

final class ArticleCell: UICollectionViewCell {
    func configure(by viewModel: ArticleViewModel) {
        self.viewModel = viewModel
        
        contentView.alpha = viewModel.isViewed ? 0.4 : 1.0
        sourceView.text = viewModel.localizedSource
        titleView.text = viewModel.title
        dateView.text = viewModel.localizedDate
        detailView.text = viewModel.description
        sourceBackgroundView.image = UIImage.roundedColoredImage(color: UIColor(hex: viewModel.localizedSource.hex) ?? .systemFill, diameter: 8.0)
        
        if viewModel.canShowDetails {
            detailView.show()
            if let imageURL = viewModel.imageURL {
                imageView.show()
                Nuke.loadImage(
                    with: imageURL,
                    options: ImageLoadingOptions(transition: .fadeIn(duration: 0.3)),
                    into: imageView
                )
            }
        } else {
            imageView.hide()
            detailView.hide()
        }
        
        updateContainerView()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateContainerView()
    }
    
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        var targetSize = targetSize
        targetSize.height = CGFloat.greatestFiniteMagnitude
        
        return super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    private func updateContainerView() {
        guard let viewModel = viewModel else { return }
        
        containerView.image = UIImage.roundedColoredImage(color: .systemFill, diameter: 8.0, alpha: viewModel.isViewed ? 0.2 : 1.0)
    }
    
    private var viewModel: ArticleViewModel?
    
    @IBOutlet private var containerView: UIImageView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var sourceView: UILabel!
    @IBOutlet private var sourceBackgroundView: UIImageView!
    @IBOutlet private var dateView: UILabel!

    @IBOutlet private var titleView: UILabel!
    @IBOutlet private var detailView: UILabel!
}
