import Foundation

public struct Response {
    public let result: Result<Data?, Error>
    
    public let request: URLRequest?
    public let response: HTTPURLResponse?
    public let data: Data?

    public init(
        request: URLRequest? = nil,
        response: HTTPURLResponse? = nil,
        data: Data? = nil,
        result: Result<Data?, Error>
    ) {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
    }
}
