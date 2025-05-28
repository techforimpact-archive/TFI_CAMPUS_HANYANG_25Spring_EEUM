import Foundation
import SwiftUI

@Observable
class AuthService: AuthServiceProtocol {
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    var qrAuthorized: Bool = false
    
    func signup(nickname: String, email: String, password: String) async throws -> Bool {
        let userInfo = SignupBodyDTO(nickname: nickname, email: email, password: password)
        let userInfoData = try jsonEncoder.encode(userInfo)
        let router = AuthHTTPRequestRouter.signup(data: userInfoData)
        let data = try await networkUtility.request(router: router)
        let signupResponse = try jsonDecoder.decode(AuthStatusResponseDTO.self, from: data)
        guard let status = signupResponse.result?.status else {
            throw AuthServiceError.noData
        }
        return status
    }
    
    func signin(email: String, password: String) async throws -> UserInfoUIO {
        let input = SigninBodyDTO(email: email, password: password)
        let inputData = try jsonEncoder.encode(input)
        let router = AuthHTTPRequestRouter.signin(data: inputData)
        let data = try await networkUtility.request(router: router)
        let signinResponse = try jsonDecoder.decode(SigninResponseDTO.self, from: data)
        guard let userInfoDTO = signinResponse.result else {
            throw AuthServiceError.noData
        }
        let userInfo = UserInfoUIO(signinResult: userInfoDTO)
        return userInfo
    }
    
    func signout() async throws -> Bool {
        let router = AuthHTTPRequestRouter.signout
        let data = try await networkUtility.request(router: router)
        let signoutResponse = try jsonDecoder.decode(AuthStatusResponseDTO.self, from: data)
        guard let status = signoutResponse.result?.status else {
            throw AuthServiceError.noData
        }
        return status
    }
    
    func refresh(refreshToken: String) async throws -> (String, String) {
        let refreshToken = RefreshBodyDTO(refreshToken: refreshToken)
        let refreshTokenData = try jsonEncoder.encode(refreshToken)
        let router = AuthHTTPRequestRouter.refresh(data: refreshTokenData)
        let data = try await networkUtility.request(router: router)
        let refreshResponse = try jsonDecoder.decode(RefreshResponseDTO.self, from: data)
        guard let result = refreshResponse.result else {
            throw AuthServiceError.noData
        }
        return (result.accessToken, result.refreshToken)
    }
    
    func passwordResetSendEmail(email: String) async throws -> (String, Int) {
        let email = EmailBodyDTO(email: email)
        let emailData = try jsonEncoder.encode(email)
        let router = AuthHTTPRequestRouter.passwordResetSendEmail(data: emailData)
        let data = try await networkUtility.request(router: router)
        let passwordResetResponse = try jsonDecoder.decode(SendEmailResponseDTO.self, from: data)
        guard let result = passwordResetResponse.result else {
            throw AuthServiceError.noData
        }
        return (result.email, result.expirationMinutes)
    }
    
    func passwordResetVerify(email: String, verificationCode: String) async throws -> (String, Bool, String) {
        let verificationInfo = VerifyBodyDTO(email: email, verificationCode: verificationCode)
        let verificationInfoData = try jsonEncoder.encode(verificationInfo)
        let router = AuthHTTPRequestRouter.passwordResetVerify(data: verificationInfoData)
        let data = try await networkUtility.request(router: router)
        let passwordResetResponse = try jsonDecoder.decode(PasswordResetVerifyResponseDTO.self, from: data)
        guard let result = passwordResetResponse.result else {
            throw AuthServiceError.noData
        }
        return (result.email, result.verified, result.resetToken)
    }
    
    func passwordResetConfirm(email: String, resetToken: String, newPassword: String) async throws -> Bool {
        let newPassword = PasswordResetBodyDTO(email: email, resetToken: resetToken, newPassword: newPassword)
        let newPasswordData = try jsonEncoder.encode(newPassword)
        let router = AuthHTTPRequestRouter.passwordResetConfirm(data: newPasswordData)
        let data = try await networkUtility.request(router: router)
        let passwordResetResponse = try jsonDecoder.decode(AuthStatusResponseDTO.self, from: data)
        guard let status = passwordResetResponse.result?.status else {
            throw AuthServiceError.noData
        }
        return status
    }
    
    func sendEmailVerification(email: String) async throws -> (String, Int) {
        let email = EmailBodyDTO(email: email)
        let emailData = try jsonEncoder.encode(email)
        let router = AuthHTTPRequestRouter.sendEmailVerification(data: emailData)
        let data = try await networkUtility.request(router: router)
        let passwordResetResponse = try jsonDecoder.decode(SendEmailResponseDTO.self, from: data)
        guard let result = passwordResetResponse.result else {
            throw AuthServiceError.noData
        }
        return (result.email, result.expirationMinutes)
    }
    
    func verifyEmail(email: String, verificationCode: String) async throws -> (String, Bool) {
        let verificationInfo = VerifyBodyDTO(email: email, verificationCode: verificationCode)
        let verificationInfoData = try jsonEncoder.encode(verificationInfo)
        let router = AuthHTTPRequestRouter.verifyEmail(data: verificationInfoData)
        let data = try await networkUtility.request(router: router)
        let emailVerifyResponse = try jsonDecoder.decode(EmailVerifyResponseDTO.self, from: data)
        guard let result = emailVerifyResponse.result else {
            throw AuthServiceError.noData
        }
        return (result.email, result.verified)
    }
    
    func checkNickname(nickname: String) async throws -> Bool {
        let router = AuthHTTPRequestRouter.checkNickname(nickname: nickname)
        let data = try await networkUtility.request(router: router)
        let checkNicknameResponse = try jsonDecoder.decode(AuthStatusResponseDTO.self, from: data)
        guard let status = checkNicknameResponse.result?.status else {
            throw AuthServiceError.noData
        }
        return status
    }
    
    func checkEmail(email: String) async throws -> Bool {
        let router = AuthHTTPRequestRouter.checkEmail(email: email)
        let data = try await networkUtility.request(router: router)
        let checkEmailResponse = try jsonDecoder.decode(AuthStatusResponseDTO.self, from: data)
        guard let status = checkEmailResponse.result?.status else {
            throw AuthServiceError.noData
        }
        return status
    }
}

enum AuthServiceError: Error {
    case noData
}
