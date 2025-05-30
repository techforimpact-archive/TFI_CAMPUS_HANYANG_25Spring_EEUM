import Foundation

enum AuthHTTPRequestRouter {
    case signup(data: Data)
    case signin(data: Data)
    case signout(token: String)
    case refresh(token: String, data: Data)
    case passwordResetSendEmail(data: Data)
    case passwordResetVerify(data: Data)
    case passwordResetConfirm(data: Data)
    case sendEmailVerification(data: Data)
    case verifyEmail(data: Data)
    case checkNickname(nickname: String)
    case checkEmail(email: String)
    case qrAuthorization(token: String, data: Data)
    case deactivate(token: String)
}

extension AuthHTTPRequestRouter: HTTPRequestable {
    var method: HTTPMethod {
        switch self {
        case .signup, .signin, .signout, .refresh, .passwordResetSendEmail, .passwordResetVerify, .passwordResetConfirm, .sendEmailVerification, .verifyEmail, .qrAuthorization:
            return .post
        case .checkNickname, .checkEmail:
            return .get
        case .deactivate:
            return .patch
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .checkNickname, .checkEmail:
            return nil
        case .signup, .signin, .passwordResetSendEmail, .passwordResetVerify, .passwordResetConfirm, .sendEmailVerification, .verifyEmail:
            return ["content-type": "application/json"]
        case .signout(let token):
            return ["Authorization": "Bearer \(token)"]
        case .refresh(let token, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        case .qrAuthorization(let token, _):
            return [
                "Authorization": "Bearer \(token)",
                "content-type": "application/json"
            ]
        case .deactivate(let token):
            return ["Authorization": "Bearer \(token)"]
        }
    }
    
    var body: Data? {
        switch self {
        case .signout, .checkNickname, .checkEmail, .deactivate:
            return nil
        case .signup(let data):
            return data
        case .signin(let data):
            return data
        case .refresh(_, let data):
            return data
        case .passwordResetSendEmail(let data):
            return data
        case .passwordResetVerify(let data):
            return data
        case .passwordResetConfirm(let data):
            return data
        case .sendEmailVerification(let data):
            return data
        case .verifyEmail(let data):
            return data
        case .qrAuthorization(_, let data):
            return data
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
            return ["v1", "auth", "email", "verify"]
        case .checkNickname:
            return ["v1", "auth", "check-nickname"]
        case .checkEmail:
            return ["v1", "auth", "check-email"]
        case .qrAuthorization:
            return ["v1", "user", "qr"]
        case .deactivate:
            return ["v1", "user", "deactivate"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .signup, .signin, .signout, .refresh, .passwordResetSendEmail, .passwordResetVerify, .passwordResetConfirm, .sendEmailVerification, .verifyEmail, .qrAuthorization, .deactivate:
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
