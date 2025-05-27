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
    
    func signin(email: String, password: String) async throws -> Bool {
        true
    }
    
    func signout() async throws -> Bool {
        true
    }
    
    func refresh(refreshToken: String) async throws -> Bool {
        true
    }
    
    func passwordResetSendEmail(email: String) async throws -> Bool {
        true
    }
    
    func passwordResetVerify(email: String, verificationCode: String) async throws -> Bool {
        true
    }
    
    func passwordResetConfirm(email: String, resetToken: String, newPassword: String) async throws -> Bool {
        true
    }
    
    func sendEmailVerification(email: String) async throws -> Bool {
        true
    }
    
    func verifyEmail(email: String, verificationToken: String) async throws -> Bool {
        true
    }
    
    func checkNickname(nickname: String) async throws -> Bool {
        true
    }
    
    func checkEmail(email: String) async throws -> Bool {
        true
    }
}
