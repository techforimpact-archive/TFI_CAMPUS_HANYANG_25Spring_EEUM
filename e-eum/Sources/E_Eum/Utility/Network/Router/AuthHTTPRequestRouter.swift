import Foundation

enum AuthHTTPRequestRouter {
    case signup(data: Data)
    case signin(data: Data)
    case signout
    case refresh(data: Data)
    case passwordResetSendEmail(data: Data)
    case passwordResetVerify(data: Data)
    case passwordResetConfirm(data: Data)
    case sendEmailVerification(data: Data)
    case verifyEmail(data: Data)
    case checkNickname(nickname: String)
    case checkEmail(email: String)
}

extension AuthHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .signup, .signin, .signout, .refresh, .passwordResetSendEmail, .passwordResetVerify, .passwordResetConfirm, .sendEmailVerification, .verifyEmail:
            return .post
        case .checkNickname, .checkEmail:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signup, .signin, .signout, .refresh, .passwordResetSendEmail, .passwordResetVerify, .passwordResetConfirm, .sendEmailVerification, .verifyEmail, .checkNickname, .checkEmail:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .signup(let data), .signin(let data), .refresh(let data), .passwordResetSendEmail(let data), .passwordResetVerify(let data), .passwordResetConfirm(let data), .sendEmailVerification(let data), .verifyEmail(let data):
            return data
        case .signout, .checkNickname, .checkEmail:
            return nil
        }
    }
    
    var host: String {
        #if os(iOS)
        return AppEnvironment.serverAddress
        #elseif os(Android)
        return ServerConfig.getServerAddress()
        #endif
    }
    
    var port: Int? { return nil }
    
    var path: [String] {
        switch self {
        case .signup:
            return ["v1", "auth", "signup"]
        case .signin:
            return ["v1", "auth", "signin"]
        case .signout:
            return ["v1", "auth", "signout"]
        case .refresh:
            return ["v1", "auth", "refresh"]
        case .passwordResetSendEmail:
            return ["v1", "auth", "password-reset", "send-verification"]
        case .passwordResetVerify:
            return ["v1", "auth", "password-reset", "verify"]
        case .passwordResetConfirm:
            return ["v1", "auth", "password-reset", "confirm"]
        case .sendEmailVerification:
            return ["v1", "auth", "email", "send-verification"]
        case .verifyEmail:
            return ["v1", "auth", "verify"]
        case .checkNickname:
            return ["v1", "auth", "check-nickname"]
        case .checkEmail:
            return ["v1", "auth", "check-email"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .signup, .signin, .signout, .refresh, .passwordResetSendEmail, .passwordResetVerify, .passwordResetConfirm, .sendEmailVerification, .verifyEmail:
            return nil
        case .checkNickname(let nickname):
            let queryItems = [
                URLQueryItem(name: "nickname", value: nickname)
            ]
            return queryItems
        case .checkEmail(let email):
            let queryItems = [
                URLQueryItem(name: "email", value: email)
            ]
            return queryItems
        }
    }
}
