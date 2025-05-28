import Foundation
import SkipKeychain

struct KeychainUtility {
    private let keychain = Keychain.shared
    
    func saveAuthToken(tokenType: TokenType, token: String) {
        do {
            try keychain.set(token, forKey: tokenType.rawValue)
        } catch {
            print("토큰 저장 실패: \(error)")
        }
    }
    
    func getAuthToken(tokenType: TokenType) -> String? {
        do {
            return try keychain.string(forKey: tokenType.rawValue)
        } catch {
            print("토큰 읽기 실패: \(error)")
            return nil
        }
    }
}

enum TokenType: String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
}
