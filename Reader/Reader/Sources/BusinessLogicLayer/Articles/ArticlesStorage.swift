import Foundation
import Storage

protocol ArticlesStorageService {
    func getArticles() -> [Articles]
    func storeArticles(_ article: Articles)
    func removeArticles(_ article: Articles)
}

final class ArticlesStorageServiceImpl: ArticlesStorageService {
    init(storage: CoreDataStorage) {
        self.storage = storage
    }
    
    func getArticles() -> [Articles] {
        let resources: [ResourceEntity] = storage.get()
        return resources.compactMap { Articles.from(entity: $0) }
    }
    
    func storeArticles(_ article: Articles) {
        let resources: [ResourceEntity] = storage.get()
        
        if let resourceBySource = resources.first(where: { $0.source == article.source.rawValue }) {
            storage.delete(entity: resourceBySource)
        }
        
        let resourceEntity: ResourceEntity = storage.create()
        let articleEntities: [ResourceArticleEntity] = article.items.map {
            let entity: ResourceArticleEntity = storage.create()
            $0.write(to: entity)
            return entity
        }
        
        article.write(articles: articleEntities, to: resourceEntity)
        storage.add(entity: resourceEntity)
    }
    
    func removeArticles(_ article: Articles) {
        let resources: [ResourceEntity] = storage.get()
        guard let resource = resources.first(where: { $0.source == article.source.rawValue }) else { return }
        
        storage.delete(entity: resource)
    }
    
    private let storage: CoreDataStorage
}

private extension ArcticleModel {
    func write(to entity: StorageEntity) {
        entity.setValue(id, forKey: "id")
        entity.setValue(url.absoluteString, forKey: "url")
        entity.setValue(title, forKey: "title")
        entity.setValue(description, forKey: "detail")
        entity.setValue(createdAt, forKey: "createdAt")
        entity.setValue(imageURL?.absoluteString, forKey: "imageURL")
    }
}

private extension Articles {
    func write(articles: [StorageEntity], to entity: StorageEntity) {
        entity.setValue(source.rawValue, forKey: "source")
        entity.setValue(NSSet(array: articles), forKey: "articles")
    }
    
    static func from(entity: ResourceEntity) -> Articles? {
        guard let source = ArticleSource(rawValue: entity.source ?? "") else { return nil }
        
        let articles = entity.articles ?? NSSet(array: [StorageEntity]())
        return Articles(
            source: source,
            items: articles.map { Article(entity: $0 as! StorageEntity) }
        )
    }
}

private struct Article: ArcticleModel {
    let id: String
    let url: URL
    let imageURL: URL?
    let title: String
    let description: String
    let createdAt: Date
    
    init(entity: StorageEntity) {
        id = entity.value(forKey: "id") as! String
        url = URL(string: entity.value(forKey: "url") as! String)!
        if let imageURLString = entity.value(forKey: "imageURL") as? String {
            imageURL = URL(string: imageURLString)
        } else {
            imageURL = nil
        }
        title = entity.value(forKey: "title") as! String
        description = entity.value(forKey: "detail") as! String
        createdAt = entity.value(forKey: "createdAt") as! Date
    }
}
