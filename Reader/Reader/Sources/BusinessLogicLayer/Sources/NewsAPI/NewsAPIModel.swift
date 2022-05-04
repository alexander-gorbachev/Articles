import Foundation

struct NewsAPIModel: Decodable {
    let articles: [Article]
}

extension NewsAPIModel {
    struct Article: Decodable, Hashable {
        let title: String
        let description: String
        let url: URL
        let urlToImage: URL?
        let publishedAt: Date
    }
}

extension NewsAPIModel.Article: ArcticleModel {
    var id: String { url.absoluteString.MD5 }
    var imageURL: URL? { urlToImage }
    var createdAt: Date { publishedAt }
}
