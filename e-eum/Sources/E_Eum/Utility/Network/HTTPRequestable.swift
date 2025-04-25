import Foundation

protocol HTTPRequestable: URLComposable {
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    
    func asURLRequest() throws -> URLRequest
}

extension HTTPRequestable {
    var scheme: String { "http" }
    
    func asURLRequest() throws -> URLRequest {
        let url = try configureURL()
        
        var request = URLRequest(url: url)
        request.httpMethod = method.description
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        return request
    }
}
