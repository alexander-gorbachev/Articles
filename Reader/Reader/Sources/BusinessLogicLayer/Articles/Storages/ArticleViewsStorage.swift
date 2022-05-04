import Foundation

import Foundation

protocol ArticleViewsStorage {
    func setIsViewed(articleId: String, from source: ArticleSource)
    func viewedArticlesIds(for source: ArticleSource) -> [String]
    
    func removeArticlesIds(for source: ArticleSource)
}

final class ArticleViewsStorageImpl: ArticleViewsStorage {
    init(storage: KeyValueStoring) {
        self.storage = storage
    }
    
    func setIsViewed(articleId: String, from source: ArticleSource) {
        var storingModel = obtainStoringModel()
        
        var ids = storingModel[source.rawValue] ?? []
        guard !ids.contains(articleId) else { return }
        
        ids.append(articleId)
        storingModel[source.rawValue] = ids
        
        storage.set(value: storingModel, by: articleViewsStorageKey)
    }
    
    func removeArticlesIds(for source: ArticleSource) {
        var storingModel = obtainStoringModel()
        
        storingModel[source.rawValue] = []
        storage.set(value: storingModel, by: articleViewsStorageKey)
    }
    
    func viewedArticlesIds(for source: ArticleSource) -> [String] {
        obtainStoringModel()[source.rawValue] ?? []
    }
    
    private func obtainStoringModel() -> [String: [String]] {
        return storage.get(by: articleViewsStorageKey) ?? [:]
    }
    
    private let storage: KeyValueStoring
    private var articleViewsStorageKey: String { #function }
}
