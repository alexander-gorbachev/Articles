import UIKit

final class ArticlesViewController: UIViewController {
    var presenter: ArticlesPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 4.0, left: 0.0, bottom: 4.0, right: 0.0)
        collectionView.dataSource = dataSource
        
        messageView.delegate = self

        presenter?.didLoadView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.invalidateLayout()
        })
    }
    
    @IBAction private func didTapPreference() {
        presenter?.didSelectPreferences()
    }
    
    @IBAction private func didTapDetails() {
        presenter?.didSelectChangeAppearance()
    }
    
    private var viewModels: [ArticleViewModel]?
    private lazy var dataSource: ArticlesDataSource = {
        let dataSource = ArticlesDataSource(collectionView: collectionView) { (collectionView, indexPath, viewModel) -> UICollectionViewCell? in
            let view = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCell.reuseIdentifier, for: indexPath)
            switch view {
            case let articleCell as ArticleCell:
                articleCell.configure(by: viewModel)
            default:
                break
            }
            return view
        }
     
        return dataSource
    }()
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var messageView: MessageView!
    @IBOutlet private var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet private var preferensesBarButtonItem: UIBarButtonItem!
    @IBOutlet private var changeAppearanceBarButtonItem: UIBarButtonItem!
}

private typealias ArticlesDataSource = UICollectionViewDiffableDataSource<Int, ArticleViewModel>
private typealias ArticlesSnapshot = NSDiffableDataSourceSnapshot<Int, ArticleViewModel>

extension ArticlesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModels?[indexPath.item] else { return }
        
        presenter?.didSelect(article: viewModel)
    }
}

extension ArticlesViewController: ArticlesView {
    func showTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func showArticles(_ articles: [ArticleViewModel]) {
        if articles.isEmpty {
            messageView.isHidden = false
            messageView.set(detail: "No articles were found 🤷‍♂️. Check preferences")
            messageView.set(action: "Go to preferences")
        } else {
            messageView.isHidden = true
        }
                
        invalidateLayout()
        applySnapshot(articles: articles, animatingDifferences: viewModels == nil)
    }
    
    func showLoading(_ isLoading: Bool) {
        guard isLoading else { return }
        messageView.isHidden = true
    }
    
    func showError(_ error: String) {
        messageView.isHidden = false
        
        messageView.configure(by: error)
    }
    
    func update(article: ArticleViewModel) {        
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([article])
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setPreferences(enabled isEnabled: Bool) {
        preferensesBarButtonItem.isEnabled = isEnabled
    }
    
    func setChangeAppearance(enabled isEnabled: Bool) {
        changeAppearanceBarButtonItem.isEnabled = isEnabled
    }
    
    func reloadAppearance() {
        var snapshot = dataSource.snapshot()
        let identifiers = collectionView.indexPathsForVisibleItems.map { snapshot.itemIdentifiers[$0.item] }
        
        snapshot.reconfigureItems(identifiers)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func applySnapshot(articles: [ArticleViewModel], animatingDifferences: Bool) {
        var snapshot = ArticlesSnapshot()
        
        snapshot.appendSections([0])
        snapshot.appendItems(articles)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
        viewModels = articles
    }
}

extension ArticlesViewController: MessageViewDelegate {
    func messageViewDidActionTapped(_ view: MessageView) {
        if let viewModels = viewModels, viewModels.isEmpty {
            presenter?.didSelectPreferences()
        } else {
            presenter?.didSelectReload()
        }
    }
}

private extension ArticlesViewController {
    func invalidateLayout() {
        flowLayout.estimatedItemSize = CGSize(
            width: min(collectionView.bounds.width, collectionView.bounds.height),
            height: 66.0
        )
        flowLayout.invalidateLayout()
    }
}
