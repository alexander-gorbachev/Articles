import Foundation

protocol ArcticleModel {
    var id: String { get }
    var url: URL { get }
    var imageURL: URL? { get }
    var title: String { get }
    var description: String { get }
    var createdAt: Date { get }
}
