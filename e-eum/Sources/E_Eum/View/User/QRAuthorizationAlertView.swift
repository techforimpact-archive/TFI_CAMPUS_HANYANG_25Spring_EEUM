import SwiftUI

struct QRAuthorizationAlertView: View {
    @Environment(AuthService.self) private var authService
    
    private let qrCode: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.75jOXNJBlItFBxIAP9Ew_1Qmzfzq_D1zi0Yn59B0ZOU"
    
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
