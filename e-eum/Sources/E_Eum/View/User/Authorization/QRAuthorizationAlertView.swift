import SwiftUI

struct QRAuthorizationAlertView: View {
    @Environment(AuthService.self) private var authService
    
    @Binding var qrAuthorized: Bool
    
    @State private var qrCode: String = ""
    @State private var showQRScanner: Bool = false
    
    var body: some View {
        VStack(spacing: 32) {
            Image("eeum_icon", bundle: .module)
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("장소 정보를 보기 위해서는 QR 인증이 필요합니다.")
                .bold()
            
            BasicButton(title: "QR코드 스캔하기", disabled: .constant(false)) {
                showQRScanner = true
            }
            .frame(width: 200)
        }
        .padding(.horizontal, 16)
        .sheet(isPresented: $showQRScanner) {
            QRScannerView(qrCode: $qrCode)
                .onDisappear {
                    if qrCode != "" {
                        qrAuthorization()
                    }
                }
        }
    }
}

private extension QRAuthorizationAlertView {
    func qrAuthorization() {
        Task {
            do {
                authService.qrAuthorized = try await authService.qrAuthorization(qrCode: qrCode)
                qrAuthorized = authService.qrAuthorized
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
