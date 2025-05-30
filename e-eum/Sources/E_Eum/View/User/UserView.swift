import SwiftUI

struct UserView: View {
    @Environment(AuthService.self) private var authService
    
    private let qrCode: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.75jOXNJBlItFBxIAP9Ew_1Qmzfzq_D1zi0Yn59B0ZOU"
    
    @Binding var qrAuthorized: Bool
    
    @State private var showSignOutAlert: Bool = false
    @State private var showDeactivateAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("유저 로그인 및 인증 정보, 설정 등이 들어갈 화면입니다.")
            
            if authService.userInfo != nil && !qrAuthorized {
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
            
            Spacer()
            
            if authService.userInfo != nil {
                HStack {
                    Button {
                        showSignOutAlert = true
                    } label: {
                        Text("로그아웃")
                            .underline()
                            .foregroundStyle(Color.gray)
                    }
                    
                    Button {
                        showDeactivateAlert = true
                    } label: {
                        Text("회원탈퇴")
                            .underline()
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
        .padding(16)
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
        .alert("회원탈퇴 하시겠습니까?", isPresented: $showDeactivateAlert) {
            Button(role: .cancel) {
                showDeactivateAlert = false
            } label: {
                Text("취소")
            }
            
            Button(role: .destructive) {
                deactivate()
            } label: {
                Text("회원탈퇴")
            }
        }
    }
}

private extension UserView {
    func signOut() {
        Task {
            do {
                _ = try await authService.signout()
                qrAuthorized = false
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deactivate() {
        Task {
            do {
                _ = try await authService.deactivate()
                authService.userInfo = nil
                authService.qrAuthorized = false
                qrAuthorized = false
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
