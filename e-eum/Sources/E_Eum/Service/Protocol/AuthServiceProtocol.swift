import Foundation

protocol AuthServiceProtocol {
    func signUp(nickname: String, email: String, password: String) async throws -> Bool
    func login(email: String, password: String) async throws -> Bool
}
