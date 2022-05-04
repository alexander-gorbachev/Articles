import Foundation

public enum HTTPError {
    case invalidURL
    case parameterEncodingFailed
}

extension HTTPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Can't create URL"
        case .parameterEncodingFailed:
            return "Can't encode parameters"
        }
    }
}
