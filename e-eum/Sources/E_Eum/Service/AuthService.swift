import Foundation
import SwiftUI

@Observable
class AuthService: AuthServiceProtocol {
    private let networkUtility: NetworkUtility = NetworkUtility()
    private let jsonDecoder: JSONDecoder = JSONDecoder()
    private let jsonEncoder: JSONEncoder = JSONEncoder()
    
    var userInfo: UserInfoUIO?
    var qrAuthorized: Bool = false
    
    func signup(nickname: String, email: String, password: String) async throws -> Bool {
        let userInfo = SignupBodyDTO(nickname: nickname, email: email, password: password)
        let userInfoData = try jsonEncoder.encode(userInfo)
        let router = AuthHTTPRequestRouter.signup(data: userInfoData)
        let data = try await networkUtility.request(router: router)
        let signupResponse = try jsonDecoder.decode(AuthStatusResponseDTO.self, from: data)
        if signupResponse.isSuccess {
            guard let status = signupResponse.result?.status else {
                throw AuthServiceError.noData
            }
            return status
        }
        return false
    }
    
    func signin(email: String, password: String) async throws -> Bool {
        let input = SigninBodyDTO(email: email, password: password)
        let inputData = try jsonEncoder.encode(input)
        let router = AuthHTTPRequestRouter.signin(data: inputData)
        let data = try await networkUtility.request(router: router)
        let signinResponse = try jsonDecoder.decode(SigninResponseDTO.self, from: data)
        if signinResponse.isSuccess {
            guard let userInfoDTO = signinResponse.result else {
                throw AuthServiceError.noData
            }
            self.userInfo = UserInfoUIO(signinResult: userInfoDTO)
            if let accessToken = KeychainUtility.shared.getAuthToken(tokenType: .accessToken) {
                if accessToken != userInfoDTO.accessToken {
                    KeychainUtility.shared.removeAuthToken(tokenType: .accessToken)
                    guard let refreshToken = KeychainUtility.shared.getAuthToken(tokenType: .refreshToken) else {
                        throw AuthServiceError.tokenError
                    }
                    try await refresh(refreshToken: refreshToken)
                }
            } else {
                KeychainUtility.shared.saveAuthToken(tokenType: .accessToken, token: userInfoDTO.accessToken)
                KeychainUtility.shared.saveAuthToken(tokenType: .refreshToken, token: userInfoDTO.refreshToken)
            }
            return signinResponse.isSuccess
        }
        return signinResponse.isSuccess
    }
    
    func signout() async throws -> Bool {
        guard let token = userInfo?.accessToken else {
            throw AuthServiceError.tokenError
        }
        let router = AuthHTTPRequestRouter.signout(token: token)
        let data = try await networkUtility.request(router: router)
        let signoutResponse = try jsonDecoder.decode(AuthStatusResponseDTO.self, from: data)
        guard let status = signoutResponse.result?.status else {
            throw AuthServiceError.noData
        }
        if status {
            self.userInfo = nil
            KeychainUtility.shared.removeAuthToken(tokenType: .accessToken)
            KeychainUtility.shared.removeAuthToken(tokenType: .refreshToken)
        }
        return status
    }
    
    func refresh(refreshToken: String) async throws {
        guard let accessToken = KeychainUtility.shared.getAuthToken(tokenType: .accessToken) else {
            throw PlaceServiceError.tokenError
        }
        let refreshBodyDTO = RefreshBodyDTO(refreshToken: refreshToken)
        let refreshTokenData = try jsonEncoder.encode(refreshBodyDTO)
        let router = AuthHTTPRequestRouter.refresh(token: accessToken, data: refreshTokenData)
        let data = try await networkUtility.request(router: router)
        let refreshResponse = try jsonDecoder.decode(RefreshResponseDTO.self, from: data)
        guard let result = refreshResponse.result else {
            throw AuthServiceError.noData
        }
        KeychainUtility.shared.saveAuthToken(tokenType: .accessToken, token: result.accessToken)
        KeychainUtility.shared.saveAuthToken(tokenType: .refreshToken, token: result.refreshToken)
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
    
    func passwordResetVerify(email: String, verificationCode: String) async throws -> String {
        let verificationInfo = VerifyBodyDTO(email: email, verificationCode: verificationCode)
        let verificationInfoData = try jsonEncoder.encode(verificationInfo)
        let router = AuthHTTPRequestRouter.passwordResetVerify(data: verificationInfoData)
        let data = try await networkUtility.request(router: router)
        let passwordResetResponse = try jsonDecoder.decode(PasswordResetVerifyResponseDTO.self, from: data)
        if passwordResetResponse.isSuccess {
            guard let result = passwordResetResponse.result else {
                throw AuthServiceError.noData
            }
            if result.verified {
                return result.resetToken
            } else {
                return ""
            }
        }
        return ""
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
    
    func verifyEmail(email: String, verificationCode: String) async throws -> Bool {
        let verificationInfo = VerifyBodyDTO(email: email, verificationCode: verificationCode)
        let verificationInfoData = try jsonEncoder.encode(verificationInfo)
        let router = AuthHTTPRequestRouter.verifyEmail(data: verificationInfoData)
        let data = try await networkUtility.request(router: router)
        let emailVerifyResponse = try jsonDecoder.decode(EmailVerifyResponseDTO.self, from: data)
        if emailVerifyResponse.isSuccess {
            guard let verified = emailVerifyResponse.result?.verified else {
                throw AuthServiceError.noData
            }
            return verified
        }
        return false
    }
    
    func checkNickname(nickname: String) async throws -> Bool {
        let router = AuthHTTPRequestRouter.checkNickname(nickname: nickname)
        let data = try await networkUtility.request(router: router)
        let checkNicknameResponse = try jsonDecoder.decode(AuthStatusResponseDTO.self, from: data)
        if checkNicknameResponse.isSuccess {
            guard let status = checkNicknameResponse.result?.status else {
                throw AuthServiceError.noData
            }
            return status
        }
        return false
    }
    
    func checkEmail(email: String) async throws -> Bool {
        let router = AuthHTTPRequestRouter.checkEmail(email: email)
        let data = try await networkUtility.request(router: router)
        let checkEmailResponse = try jsonDecoder.decode(AuthStatusResponseDTO.self, from: data)
        if checkEmailResponse.isSuccess {
            guard let status = checkEmailResponse.result?.status else {
                throw AuthServiceError.noData
            }
            return status
        }
        print("이미 존재하는 이메일")
        return false
    }
}

enum AuthServiceError: Error {
    case noData
    case tokenError
}
