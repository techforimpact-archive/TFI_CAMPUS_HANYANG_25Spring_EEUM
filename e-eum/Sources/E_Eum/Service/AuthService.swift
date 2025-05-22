import Foundation
import SwiftUI

@Observable
class AuthService: AuthServiceProtocol {
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    var qrAuthorized: Bool = false
    
    func signUp(nickname: String, email: String, password: String) async throws -> Bool {
        true
    }
    
    func login(email: String, password: String) async throws -> Bool {
        true
    }
}
