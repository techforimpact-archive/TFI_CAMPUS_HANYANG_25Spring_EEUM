import SwiftUI

struct ChangePasswordView: View {
    @Environment(AuthService.self) private var authService
    @Environment(\.dismiss) private var dismiss
    
    @State private var email: String = ""
    @State private var emailVerificationSent: Bool = false
    @State private var verificationCode: String = ""
    @State private var resetToken: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var passwordVerified: Bool = false
    @State private var buttonDisabled: Bool = true
    @State private var passwordResetSuccess: Bool = false
    @State private var showPasswordChangedAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                AuthorizationTextField(input: $email, placeholder: "이메일을 입력해주세요.")
                
                Button {
                    sendEmailVerification()
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 120, height: 50)
                        .foregroundStyle(emailVerificationSent ? Color.green : Color.pink)
                        .overlay {
                            Text(emailVerificationSent ? "전송됨" : "인증번호 받기")
                                .foregroundStyle(Color.white)
                        }
                }
                .disabled(email.isEmpty)
            }
            
            HStack(spacing: 8) {
                AuthorizationTextField(input: $verificationCode, placeholder: "인증번호를 입력해주세요.")
                
                Button {
                    verifyEmail()
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 120, height: 50)
                        .foregroundStyle(resetToken == "" ? Color.pink : Color.green)
                        .overlay {
                            Text(resetToken == "" ? "인증번호 확인" : "확인됨")
                                .foregroundStyle(Color.white)
                        }
                }
                .disabled(verificationCode.count != 6)
            }
            
            AuthorizationSecureField(input: $password, placeholder: "새 비밀번호를 입력해주세요.")
            
            AuthorizationSecureField(input: $confirmPassword, placeholder: "새 비밀번호를 확인해주세요.")
                .onChange(of: confirmPassword) {
                    if password == confirmPassword {
                        passwordVerified = true
                    } else {
                        passwordVerified = false
                    }
                }
            
            Spacer()
            
            BasicButton(title: "비밀번호 변경하기", disabled: $buttonDisabled) {
                changePassword()
                if passwordResetSuccess {
                    showPasswordChangedAlert = true
                }
            }
            .frame(width: 200)
            .onChange(of: resetToken) {
                checkButtonDisabled()
            }
            .onChange(of: passwordVerified) {
                checkButtonDisabled()
            }
        }
        .padding(16)
        .navigationTitle("비밀번호 변경")
        .alert("비밀번호 변경", isPresented: $showPasswordChangedAlert) {
            Button {
                dismiss()
            } label: {
                Text("확인")
            }
        } message: {
            Text("비밀번호가 변경되었습니다.")
        }
        #if os(iOS)
        .sensoryFeedback(.success, trigger: showPasswordChangedAlert)
        #endif
    }
}

private extension ChangePasswordView {
    func checkButtonDisabled() {
        if resetToken != "" && passwordVerified {
            buttonDisabled = false
        } else {
            buttonDisabled = true
        }
    }
    
    func sendEmailVerification() {
        Task {
            do {
                _ = try await authService.passwordResetSendEmail(email: email)
                emailVerificationSent = true
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func verifyEmail() {
        Task {
            do {
                resetToken = try await authService.passwordResetVerify(email: email, verificationCode: verificationCode)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func changePassword() {
        Task {
            do {
                passwordResetSuccess = try await authService.passwordResetConfirm(email: email, resetToken: resetToken, newPassword: password)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
