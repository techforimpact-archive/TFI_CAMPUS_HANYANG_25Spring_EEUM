import Foundation

protocol AuthServiceProtocol {
    func signup(nickname: String, email: String, password: String) async throws -> Bool
    func signin(email: String, password: String) async throws -> Bool
    func signout() async throws -> Bool
    func refresh(refreshToken: String) async throws -> (String, String)
    func passwordResetSendEmail(email: String) async throws -> (String, Int)
    func passwordResetVerify(email: String, verificationCode: String) async throws -> (String, Bool, String)
    func passwordResetConfirm(email: String, resetToken: String, newPassword: String) async throws -> Bool
    func sendEmailVerification(email: String) async throws -> (String, Int)
    func verifyEmail(email: String, verificationCode: String) async throws -> Bool
    func checkNickname(nickname: String) async throws -> Bool
    func checkEmail(email: String) async throws -> Bool
}
