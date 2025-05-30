import SwiftUI

struct UserView: View {
    @Environment(AuthService.self) private var authService
    
    @State private var qrAutorized: Bool = false
    @State private var showSignOutAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("유저 로그인 및 인증 정보, 설정 등이 들어갈 화면입니다.")
            
            Toggle(isOn: $qrAutorized, label: { Text("QR코드 인증") })
                .onChange(of: qrAutorized) {
                    authService.qrAuthorized = qrAutorized
                }
            
            Spacer()
            
            if authService.userInfo != nil {
                Button {
                    showSignOutAlert = true
                } label: {
                    Text("로그아웃")
                        .underline()
                        .foregroundStyle(Color.gray)
                }
            }
        }
        .padding(16)
        .onAppear {
            qrAutorized = authService.qrAuthorized
        }
        .alert("로그아웃 하시겠습니까?", isPresented: $showSignOutAlert) {
            Button(role: .cancel) {
                showSignOutAlert = false
            } label: {
                Text("취소")
            }
            
            Button(role: .destructive) {
                signOut()
            } label: {
                Text("로그아웃")
            }
        }
    }
}

private extension UserView {
    func signOut() {
        Task {
            do {
                _ = try await authService.signout()
                qrAutorized = false
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
