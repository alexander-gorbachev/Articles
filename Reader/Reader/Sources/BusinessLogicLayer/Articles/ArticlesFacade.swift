import Foundation

protocol ArticlesFacade {
    func obtainArticles(handler: @escaping (Result<[Articles], Error>) -> Void)
}

final class ArticlesFacadeImpl: ArticlesFacade {
    init(
        newsAPIService: NewsAPIService,
        sourceStorage: ArticleSourcesStorage,
        articlesStorageService: ArticlesStorageService
    ) {
        self.newsAPIService = newsAPIService
        self.sourceStorage = sourceStorage
        self.articlesStorageService = articlesStorageService
    }
    
    func obtainArticles(handler: @escaping (Result<[Articles], Error>) -> Void) {
        let sources = sourceStorage.getEnabledSources()
        let articlesFromStorage = articlesStorageService
            .getArticles()
            .filter({ sources.contains($0.source) })
        
        if !articlesFromStorage.isEmpty {
            DispatchQueue.main.async {
                handler(.success(articlesFromStorage))
            }
        }
        
        obtainArticles(for: sources) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let articles):
                articles.forEach { self.articlesStorageService.storeArticles($0) }
                handler(.success(articles))
            case .failure(let error):
                if articlesFromStorage.isEmpty {
                    handler(.failure(error))
                }
            }
        }
    }
    
    private func obtainArticles(for sources: [ArticleSource], handler: @escaping (Result<[Articles], Error>) -> Void) {
        let group = DispatchGroup()
        var resultModel = [Articles]()
        var lastError: Error?

        sources.forEach { source in
            group.enter()
            newsAPIService.obtain(by: source.toNewsAPIServiceSource) { result in
                defer { group.leave() }

                switch result {
                case .success(let model):
                    resultModel.append(Articles(source: source, items: model.articles))
                case .failure(let error):
                    lastError = error
                }
            }
        }

        group.notify(queue: .main) {
            if resultModel.isEmpty, let error = lastError {
                handler(.failure(error))
            } else {
                handler(.success(resultModel))
            }
        }
    }
    
    private let newsAPIService: NewsAPIService
    private let sourceStorage: ArticleSourcesStorage
    private let articlesStorageService: ArticlesStorageService
}

private extension ArticleSource {
    var toNewsAPIServiceSource: NewsAPIServiceSource {
        switch self {
        case .health:
            return .health
        case .science:
            return .science
        case .business:
            return .business
        }
    }
}
