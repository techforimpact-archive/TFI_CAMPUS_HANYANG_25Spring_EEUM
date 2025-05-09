import Foundation

protocol URLComposable {
    var scheme: String { get }
    var host: String { get }
    var port: Int? { get }
    var path: [String] { get }
    var queryItems: [URLQueryItem]? { get }
    
    func configureURL() throws -> URL
}

extension URLComposable {
    func configureURL() throws -> URL {
        var components = URLComponents()
        
        components.scheme = scheme
        components.host = host
        if let port = port {
            components.port = port
        }
        components.path = "/\(path.joined(separator: "/"))"
        if let queryItems = queryItems {
            components.path += "/"
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        return url
    }
}
