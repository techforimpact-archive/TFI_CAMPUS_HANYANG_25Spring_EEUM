import Foundation
import SkipKeychain

struct KeychainUtility {
    static let shared = KeychainUtility()
    
    private let keychain = Keychain.shared
    
    func saveAuthToken(tokenType: TokenType, token: String) {
        do {
            try keychain.set(token, forKey: tokenType.rawValue)
        } catch {
            print("토큰 저장 실패: \(error.localizedDescription)")
        }
    }
    
    func getAuthToken(tokenType: TokenType) -> String? {
        do {
            return try keychain.string(forKey: tokenType.rawValue)
        } catch {
            print("토큰 읽기 실패: \(error.localizedDescription)")
            return nil
        }
    }
    
    func removeAuthToken(tokenType: TokenType) {
        do {
            try keychain.removeValue(forKey: tokenType.rawValue)
        } catch {
            print("토큰 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    func qrAuthorized() -> Bool {
        do {
            try keychain.set(true, forKey: "qrAuthorized")
            return true
        } catch {
            print("QR인증 저장 실패: \(error.localizedDescription)")
            return false
        }
    }
}

enum TokenType: String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
}
