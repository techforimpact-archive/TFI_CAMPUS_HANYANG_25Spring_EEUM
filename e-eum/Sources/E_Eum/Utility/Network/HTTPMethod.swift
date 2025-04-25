import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

extension HTTPMethod: CustomStringConvertible {
    var description: String {
        self.rawValue
    }
}
