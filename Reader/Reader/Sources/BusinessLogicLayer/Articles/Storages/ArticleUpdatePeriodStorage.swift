import Foundation

enum ArticlesUpdatePeriod: String, Equatable, CaseIterable {
    case never
    case minute
    case fiveMinutes
    case tenMinutes
}

protocol ArticleUpdatePeriodStorage {
    func set(period: ArticlesUpdatePeriod)
    func getCurrentPeriod() -> ArticlesUpdatePeriod
}

final class ArticleUpdatePeriodStorageImpl: ArticleUpdatePeriodStorage {
    init(storage: KeyValueStoring) {
        self.storage = storage
    }
    
    func set(period: ArticlesUpdatePeriod) {
        storage.set(value: period.rawValue, by: articleUpdatePeriodStorageKey)
    }
    
    func getCurrentPeriod() -> ArticlesUpdatePeriod {
        guard let value: String = storage.get(by: articleUpdatePeriodStorageKey),
              let period = ArticlesUpdatePeriod(rawValue: value) else {
            return .fiveMinutes
        }
        
        return period
    }
    
    private let storage: KeyValueStoring
    private var articleUpdatePeriodStorageKey: String { #function }
}
