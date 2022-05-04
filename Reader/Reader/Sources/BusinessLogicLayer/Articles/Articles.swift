import Foundation

struct Articles: Equatable {
    let source: ArticleSource
    let items: [ArcticleModel]
    
    static func == (lhs: Articles, rhs: Articles) -> Bool {
        guard lhs.source == rhs.source,
              lhs.items.count == rhs.items.count else {
            return false
        }
        
        let lhsIds = lhs.items.map { $0.id }
        let rhsIds = rhs.items.map { $0.id }
        return lhsIds == rhsIds
    }
}
