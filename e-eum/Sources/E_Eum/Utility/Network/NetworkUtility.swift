import Foundation

struct NetworkUtility {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request(router: any HTTPRequestable) async throws -> Data {
        let request = try router.asURLRequest()
        let (data, _) = try await session.data(for: request)
        
        return data
    }
    
    func requestWithStatusCode(router: any HTTPRequestable) async throws -> (Int, Data) {
        let request = try router.asURLRequest()
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            fatalError("Response is not HTTPURLResponse")
        }
        
        return (httpResponse.statusCode, data)
    }
}
