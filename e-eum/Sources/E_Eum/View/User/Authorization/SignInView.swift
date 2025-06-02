import SwiftUI

struct SignInView: View {
    @Environment(AuthService.self) private var authService
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var buttonDisabled: Bool = true
    @State private var autoLoginChecked: Bool = false
    @State private var showPasswordResetSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            AuthorizationTextField(input: $email, placeholder: "이메일을 입력해주세요.")
                .onChange(of: email) {
                    checkButtonDisabled()
                }
            
            AuthorizationSecureField(input: $password, placeholder: "비밀번호를 입력해주세요.")
                .onChange(of: password) {
                    checkButtonDisabled()
                }
            
            Spacer()
            
            Button {
                if autoLoginChecked {
                    autoLoginChecked = false
                } else {
                    autoLoginChecked = true
                }
            } label: {
                Label("자동 로그인", systemImage: autoLoginChecked ? "checkmark.square" : "square")
                    .foregroundStyle(autoLoginChecked ? Color.pink : Color.gray)
            }
            
            BasicButton(title: "로그인하기", disabled: $buttonDisabled) {
                if autoLoginChecked {
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(password, forKey: "password")
                }
                signIn()
            }
            .frame(width: 200)
            
            Button {
                showPasswordResetSheet = true
            } label: {
                Text("비밀번호 찾기")
                    .underline()
                    .foregroundStyle(Color.gray)
            }
        }
        .sheet(isPresented: $showPasswordResetSheet) {
            PasswordResetView()
        }
    }
}

private extension SignInView {
    func checkButtonDisabled() {
        if !email.isEmpty && !password.isEmpty {
            buttonDisabled = false
        }
    }
    
    func signIn() {
        Task {
            do {
                _ = try await authService.signin(email: email, password: password)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
