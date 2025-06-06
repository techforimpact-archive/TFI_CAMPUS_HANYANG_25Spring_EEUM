import SwiftUI

struct PasswordResetView: View {
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
    
    var body: some View {
        VStack(spacing: 16) {
            SheetHeader()
            
            Image("ddingdong_icon_1", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            
            Text("새 비밀번호 만들기")
                .font(.title2)
            
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
            
            BasicButton(title: "새 비밀번호 만들기", disabled: $buttonDisabled) {
                passwordReset()
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
        .alert("비밀번호 변경이 완료되었습니다.", isPresented: $passwordResetSuccess) {
            Button {
                dismiss()
            } label: {
                Text("확인")
            }
        }
        #if os(iOS)
        .sensoryFeedback(.success, trigger: passwordResetSuccess)
        #endif
    }
}

private extension PasswordResetView {
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
    
    func passwordReset() {
        Task {
            do {
                passwordResetSuccess = try await authService.passwordResetConfirm(email: email, resetToken: resetToken, newPassword: password)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
