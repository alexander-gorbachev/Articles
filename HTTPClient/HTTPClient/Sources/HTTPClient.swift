import Foundation

public protocol HTTPClient: AnyObject {
    @discardableResult
    func request(
        for target: HTTPTarget,
        responseQueue queue: DispatchQueue,
        responceHandler: @escaping (Response) -> Void
    ) -> HTTPRequest?
}

public extension HTTPClient {
    @discardableResult
    func request(for target: HTTPTarget, responceHandler: @escaping (Response) -> Void) -> HTTPRequest? {
        request(for: target, responseQueue: .main, responceHandler: responceHandler)
    }
}

public final class HTTPClientImpl {
    public init() {
        self.session = URLSession.shared
    }
    
    private let session: URLSession
}

extension HTTPClientImpl: HTTPClient {
    public func request(
        for target: HTTPTarget,
        responseQueue queue: DispatchQueue,
        responceHandler: @escaping (Response) -> Void
    ) -> HTTPRequest? {
        let result = request(from: target)
        switch result {
        case .success(let URLRequest):
            return session.dataTask(with: URLRequest) { data, response, error in
                queue.async {
                    let dataResponse = Response(
                        request: URLRequest,
                        response: response as? HTTPURLResponse,
                        data: data,
                        result: .success(data)
                    )
                    responceHandler(dataResponse)
                }
            }
        case .failure(let error):
            queue.async { responceHandler(Response(result: .failure(error))) }
            return nil
        }
    }
}

extension URLSessionTask: HTTPRequest {
    public var id: Int { taskIdentifier }
    public var request: URLRequest? { currentRequest }
}

private extension HTTPClientImpl {
    func request(from target: HTTPTarget) -> Result<URLRequest, Error> {
        guard let url = URL(string: "\(target.baseURL)\(target.path)") else {
            return .failure(HTTPError.invalidURL)
        }
        switch target.method {
        case .get:
            let encoder = URLEncoder()
            do {
                let requestURL = try encoder.encode(url: url, with: target.parameters)
                let request = URLRequest(
                    url: requestURL,
                    method: target.method,
                    headers: target.headers
                )
                return .success(request)
            } catch let error {
                return .failure(error)
            }
        }
    }
}

private extension URLRequest {
    init(url: URL, method: HTTPMethod, headers: [String: String]? = nil) {
        self.init(url: url)

        httpMethod = method.rawValue
        allHTTPHeaderFields = headers
    }
}
