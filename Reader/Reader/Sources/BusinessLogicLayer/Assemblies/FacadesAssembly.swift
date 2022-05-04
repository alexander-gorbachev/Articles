import Foundation

struct FacadesAssembly {
    func assembly() {
        assemblyArticleFacades()
    }
}

private extension FacadesAssembly {
    func assemblyArticleFacades() {
        Dependency.register(ArticleUpdateFacade.self, lifetime: .transient) {
            ArticleUpdateFacadeImpl(
                storage: Dependency.resolve(),
                updateService: Dependency.resolve(),
                updateServiceObservable: Dependency.resolve()
            )
        }
        Dependency.register(ArticlesFacade.self, lifetime: .transient) {
            ArticlesFacadeImpl(
                newsAPIService: Dependency.resolve(),
                sourceStorage: Dependency.resolve(),
                articlesStorageService: Dependency.resolve()
            )
        }
    }
}
