import Foundation

protocol ArticleSourcesStorage {
    func set(source: ArticleSource, enabled: Bool)
    func getEnabledSources() -> [ArticleSource]
}

final class ArticleSourcesStorageImpl: ArticleSourcesStorage {
    init(storage: KeyValueStoring) {
        self.storage = storage
        setupIfNeeded()
    }
    
    func set(source: ArticleSource, enabled: Bool) {
        var storingModel: [String: Bool] = obtainStoringModel()
        storingModel[source.rawValue] = enabled
        
        storage.set(value: storingModel, by: articleSourcesStorageKey)
    }
    
    func getEnabledSources() -> [ArticleSource] {
        return obtainStoringModel()
            .lazy
            .filter { $0.value }
            .compactMap { ArticleSource(rawValue: $0.key) }
    }
    
    private func setupIfNeeded() {
        guard obtainStoringModel().isEmpty else { return }
        
        let storingModel = ArticleSource.allCases.reduce(into: [String: Bool]()) { $0[$1.rawValue] = true }
        storage.set(value: storingModel, by: articleSourcesStorageKey)
    }
    
    private func obtainStoringModel() -> [String: Bool] {
        return storage.get(by: articleSourcesStorageKey) ?? [:]
    }
    
    private let storage: KeyValueStoring
    private var articleSourcesStorageKey: String { #function }
}
