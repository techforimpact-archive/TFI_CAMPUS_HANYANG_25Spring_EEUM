import Foundation
import SwiftUI

@Observable
class AuthService: AuthServiceProtocol {
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    var qrAuthorized: Bool = false
    
    func signup(nickname: String, email: String, password: String) async throws -> Bool {
        true
    }
    
    func signin(email: String, password: String) async throws -> UserInfoUIO {
        UserInfoUIO(userId: "123", nickname: "tester", email: "test@email.com", accessToken: "asd", refreshToken: "qwe")
    }
    
    func signout() async throws -> Bool {
        true
    }
    
    func refresh(refreshToken: String) async throws -> (String, String) {
        ("asd", "qwe")
    }
    
    func passwordResetSendEmail(email: String) async throws -> (String, Int) {
        ("test@email.com", 5)
    }
    
    func passwordResetVerify(email: String, verificationCode: String) async throws -> (String, Bool, String) {
        ("test@email.com", true, "zxc")
    }
    
    func passwordResetConfirm(email: String, resetToken: String, newPassword: String) async throws -> Bool {
        true
    }
    
    func sendEmailVerification(email: String) async throws -> (String, Int) {
        ("test@email.com", 5)
    }
    
    func verifyEmail(email: String, verificationToken: String) async throws -> (String, Bool) {
        ("test@email.com", true)
    }
    
    func checkNickname(nickname: String) async throws -> Bool {
        true
    }
    
    func checkEmail(email: String) async throws -> Bool {
        true
    }
}
