import Foundation
import HTTPClient

enum NewsAPIServiceSource: String {
    case health, science, business
}

protocol NewsAPIService {
    func obtain(by source: NewsAPIServiceSource, with handler: @escaping (Result<NewsAPIModel, Error>) -> Void)
}

final class NewsAPIServiceImpl: NewsAPIService {
    init(HTTPClient: HTTPClient, APIKey: String) {
        self.HTTPClient = HTTPClient
        self.APIKey = APIKey
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .formatted(.iso8601)
    }
    
    func obtain(by source: NewsAPIServiceSource, with handler: @escaping (Result<NewsAPIModel, Error>) -> Void) {
        HTTPClient.request(
            for: NewsAPITarget(source: source, APIKey: APIKey),
            responseQueue: .global(qos: .utility),
            responceHandler: { [weak self] in
                guard let self = self else { return }
                
                let mainQueue = DispatchQueue.main
                switch $0.result {
                case .success(let data):
                    guard let data = data else {
                        mainQueue.async { handler(.failure(NewsAPIServiceError.emptyData)) }
                        return
                    }
                    do {
                        let model = try self.decoder.decode(NewsAPIModel.self, from: data)
                        mainQueue.async { handler(.success(model)) }
                    } catch {
                        mainQueue.async { handler(.failure(NewsAPIServiceError.decodingError)) }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        handler(.failure(error))
                    }
                }
            }
        )?.resume()
    }
    
    private let HTTPClient: HTTPClient
    private let APIKey: String
    private let decoder: JSONDecoder
}

enum NewsAPIServiceError {
    case emptyData
    case decodingError
}

extension NewsAPIServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyData,
             .decodingError:
            return "Error while processing data from the server. Please, Try again later"
        }
    }
}

private struct NewsAPITarget: HTTPTarget {
    let baseURL: String
    let path: String
    let method: HTTPMethod
    let parameters: [String : Any]?
    let headers: [String : String]?
        
    init(source: NewsAPIServiceSource, APIKey: String) {
        self.baseURL = "https://newsapi.org"
        self.path = "/v2/everything"
        self.method = .get
        self.parameters = [
            "q": source.rawValue,
            "from": DateFormatter.yearMonthDay.string(from: Date()),
            "apiKey": APIKey
        ]
        self.headers = nil
    }
}
