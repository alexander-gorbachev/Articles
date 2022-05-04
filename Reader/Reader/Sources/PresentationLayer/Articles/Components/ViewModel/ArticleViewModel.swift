import Foundation

final class ArticleViewModel: Equatable, Hashable {
    let id: String
    let title: String
    let description: String
    let imageURL: URL?
    let localizedSource: String
    let localizedDate: String
    let createdDate: Date
    
    var isViewed: Bool
    var canShowDetails: Bool

    let source: ArticleSource
    
    init(
        model: ArcticleModel,
        source: ArticleSource,
        isViewed: Bool = false,
        canShowDetails: Bool
    ) {
        self.id = model.id
        self.title = model.title
        self.description = model.description
        self.imageURL = model.imageURL
        self.localizedSource = source.rawValue.uppercased()
        self.localizedDate = DateFormatter.timeHoursMinutes.string(from: model.createdAt)
        self.createdDate = model.createdAt
        
        self.isViewed = isViewed
        self.canShowDetails = canShowDetails

        self.source = source
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ArticleViewModel, rhs: ArticleViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
