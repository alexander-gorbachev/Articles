import Foundation

struct URLEncoder {
    func encode(url: URL, with parameters: [String: Any]? = nil) throws -> URL {
        guard let parameters = parameters,
              !parameters.isEmpty else {
            return url
        }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let queryParameters = query(from: parameters)
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + queryParameters
            urlComponents.percentEncodedQuery = percentEncodedQuery
            guard let encodedURL = urlComponents.url else {
                throw HTTPError.parameterEncodingFailed
            }
            return encodedURL
        }

        return url
    }
}

private extension URLEncoder {
    func queryComponents(key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        switch value {
        case let dictionaryValue as [String: Any]:
            dictionaryValue.forEach {
                components += queryComponents(key: "\(key)[\($0.key)]", value: $0.value)
            }
        case let arrayValue as [Any]:
            arrayValue.forEach {
                components += queryComponents(key: "\(key)[]", value: $0)
            }
        case let boolValue as Bool:
            components.append((key.percentEncoding, boolValue ? "1" : "0" ))
        default:
            components.append((key.percentEncoding, "\(value)".percentEncoding))
        }
        return components
    }
    
    func query(from parameters: [String: Any]) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(key: key, value: value)
        }
        return components.map({ "\($0)=\($1)" }).joined(separator: "&")
    }
}

private extension String {
    var percentEncoding: String { addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self }
}
