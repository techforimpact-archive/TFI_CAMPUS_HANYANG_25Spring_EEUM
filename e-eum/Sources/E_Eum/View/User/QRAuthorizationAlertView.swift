import SwiftUI

struct QRAuthorizationAlertView: View {
    @Environment(AuthService.self) private var authService
    
    @State private var qrAutorized: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("QR 인증하세요.")
            
            Toggle(isOn: $qrAutorized, label: { Text("QR코드 인증") })
                .onChange(of: qrAutorized) {
                    authService.qrAuthorized = qrAutorized
                }
        }
        .padding(.horizontal, 16)
        .onAppear {
            qrAutorized = authService.qrAuthorized
        }
    }
}
