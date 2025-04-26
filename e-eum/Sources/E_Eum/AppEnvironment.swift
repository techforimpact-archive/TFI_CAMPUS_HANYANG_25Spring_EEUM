import Foundation

struct AppEnvironment {
    static let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    
    static let serverIPAddress = Bundle.main.infoDictionary?["SERVER_IT_ADDRESS"] as? String ?? ""
}
