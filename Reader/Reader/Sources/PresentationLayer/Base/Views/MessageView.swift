import UIKit

protocol MessageViewDelegate: AnyObject {
    func messageViewDidActionTapped(_ view: MessageView)
}

final class MessageView: UIView {
    weak var delegate: MessageViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    func set(title: String) {
        titleView.text = title
    }
    
    func set(detail: String) {
        detailView.text = detail
    }
    
    func set(action: String) {
        actionView.setTitle(action, for: .normal)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        actionView.setBackgroundImage(UIImage.roundedColoredImage(color: .systemOrange, diameter: 18.0), for: .normal)
    }
    
    private func commonInit() {
        setupContainer()
        setupTitleView()
        setupDetailView()
        setupActionView()
    }
    
    private let container = UIView()
    private let titleView = UILabel()
    private let detailView = UILabel()
    private let actionView = UIButton()
}

extension MessageView {
    func configure(by error: String) {
        titleView.text = "Ooooops..."
        detailView.text = error
        actionView.setTitle("Try again", for: .normal)
    }
}

private extension MessageView {
    func setupContainer() {
        container.backgroundColor = .clear
        
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            container.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setupTitleView() {
        titleView.text = "Ooooops..."
        titleView.font = UIFont.boldSystemFont(ofSize: 32.0)
        titleView.numberOfLines = 0
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: container.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }
    
    func setupDetailView() {
        detailView.text = "There was a problem with you data"
        detailView.font = UIFont.systemFont(ofSize: 18.0)
        detailView.textColor = .systemGray
        detailView.numberOfLines = 0
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(detailView)
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 32.0),
            detailView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }
    
    func setupActionView() {
        actionView.setTitle("Try again", for: .normal)
        actionView.setBackgroundImage(UIImage.roundedColoredImage(color: .systemOrange, diameter: 18.0), for: .normal)
        actionView.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            
            self.delegate?.messageViewDidActionTapped(self)
        }), for: .touchUpInside)
        
        actionView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(actionView)
        
        NSLayoutConstraint.activate([
            actionView.topAnchor.constraint(equalTo: detailView.bottomAnchor, constant: 16.0),
            actionView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            actionView.widthAnchor.constraint(equalTo: container.widthAnchor),
            actionView.heightAnchor.constraint(equalToConstant: 44.0),
            actionView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}
