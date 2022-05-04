import Foundation

public protocol HTTPTarget: CustomDebugStringConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

public extension HTTPTarget {
    var debugDescription: String {
        var descriptionData = [""]

        descriptionData.append(contentsOf: [
            "Method: \(method.rawValue)",
            "URL: \(baseURL)",
            "Path: \(path)"
        ])
        
        if let params = parameters {
            descriptionData.append("Parameters: \(params)")
        }
        
        return descriptionData.joined(separator: "\n")
    }
}
