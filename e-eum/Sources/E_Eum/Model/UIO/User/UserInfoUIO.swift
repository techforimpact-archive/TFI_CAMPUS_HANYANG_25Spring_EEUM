import Foundation

struct UserInfoUIO {
    let userId: String
    let nickname: String
    let email: String
    let accessToken: String
    let refreshToken: String
    
    init(userId: String, nickname: String, email: String, accessToken: String, refreshToken: String) {
        self.userId = userId
        self.nickname = nickname
        self.email = email
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    init(signinResult: SigninResultDTOContainer) {
        self.userId = signinResult.userId
        self.nickname = signinResult.nickname
        self.email = signinResult.email
        self.accessToken = signinResult.accessToken
        self.refreshToken = signinResult.refreshToken
    }
}
