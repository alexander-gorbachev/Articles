import Foundation

public protocol HTTPRequest {
    var id: Int { get }
    var request: URLRequest? { get }
    
    func resume()
    func cancel()
}
