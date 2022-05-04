import Foundation
import CryptoKit

extension StringProtocol {
    var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
    
    var hex: String { "#\(MD5.prefix(8))" }
}
