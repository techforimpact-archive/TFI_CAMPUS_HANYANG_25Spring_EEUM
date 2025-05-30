import SwiftUI

struct QRAuthorizationAlertView: View {
    @Environment(AuthService.self) private var authService
    
    private let qrCode: String = Bundle.main.infoDictionary?["QR_CODE"] as? String ?? ""
    
    @Binding var qrAuthorized: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Text("QR 인증하세요.")
            
            Button {
                Task {
                    do {
                        authService.qrAuthorized = try await authService.qrAuthorization(qrCode: qrCode)
                        qrAuthorized = authService.qrAuthorized
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("QR코드 인증")
            }
        }
        .padding(.horizontal, 16)
    }
}
