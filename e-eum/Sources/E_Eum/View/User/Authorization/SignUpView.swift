import SwiftUI

struct SignUpView: View {
    @Environment(AuthService.self) private var authService
    
    @Binding var viewType: ViewType
    
    @State private var email: String = ""
    @State private var emailVerificationSent: Bool = false
    @State private var emailVerificationCode: String = ""
    @State private var emailVerified: Bool?
    @State private var nickname: String = ""
    @State private var nicknameVerified: Bool?
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var passwordVerified: Bool = false
    @State private var buttonDisabled: Bool = true
    @State private var signUpSuccess: Bool = false
    
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
                AuthorizationTextField(input: $emailVerificationCode, placeholder: "인증번호를 입력해주세요.")
                
                Button {
                    verifyEmail()
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 120, height: 50)
                        .foregroundStyle(emailVerified == nil ? Color.pink : emailVerified! ? Color.green : Color.red)
                        .overlay {
                            Text(emailVerified == nil ? "인증번호 확인" : emailVerified! ? "사용 가능" : "인증번호 틀림")
                                .foregroundStyle(Color.white)
                        }
                }
                .disabled(emailVerificationCode.count != 6)
            }
            
            HStack(spacing: 8) {
                AuthorizationTextField(input: $nickname, placeholder: "닉네임을 입력해주세요.")
                
                Button {
                    checkNickname()
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 120, height: 50)
                        .foregroundStyle(nicknameVerified == nil ? Color.pink : nicknameVerified! ? Color.green : Color.red)
                        .overlay {
                            Text(nicknameVerified == nil ? "닉네임 중복 확인" : nicknameVerified! ? "사용 가능" : "닉네임 중복")
                                .foregroundStyle(Color.white)
                        }
                }
                .disabled(nickname.isEmpty)
            }
            .onChange(of: nickname) {
                nicknameVerified = nil
            }
            
            AuthorizationSecureField(input: $password, placeholder: "비밀번호를 입력해주세요.")
            
            AuthorizationSecureField(input: $confirmPassword, placeholder: "비밀번호를 확인해주세요.")
                .onChange(of: confirmPassword) {
                    if password == confirmPassword {
                        passwordVerified = true
                    } else {
                        passwordVerified = false
                    }
                }
            
            Spacer()
            
            BasicButton(title: "회원가입하기", disabled: $buttonDisabled) {
                signUp()
            }
            .frame(width: 200)
            .onChange(of: emailVerified) {
                checkButtonDisabled()
            }
            .onChange(of: nicknameVerified) {
                checkButtonDisabled()
            }
            .onChange(of: passwordVerified) {
                checkButtonDisabled()
            }
        }
        .alert("회원가입 되었습니다.", isPresented: $signUpSuccess) {
            Button {
                viewType = .signin
            } label: {
                Text("로그인 하기")
            }
        }
        #if os(iOS)
        .sensoryFeedback(.success, trigger: signUpSuccess)
        #endif
    }
}

private extension SignUpView {
    func checkButtonDisabled() {
        if let emailVerified = emailVerified, let nicknameVerified = nicknameVerified {
            if emailVerified && nicknameVerified && passwordVerified {
                buttonDisabled = false
            } else {
                buttonDisabled = true
            }
        } else {
            buttonDisabled = true
        }
    }
    
    func sendEmailVerification() {
        Task {
            do {
                if try await authService.checkEmail(email: email) {
                    _ = try await authService.sendEmailVerification(email: email)
                    emailVerificationSent = true
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func verifyEmail() {
        Task {
            do {
                emailVerified = try await authService.verifyEmail(email: email, verificationCode: emailVerificationCode)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func checkNickname() {
        Task {
            do {
                nicknameVerified = try await authService.checkNickname(nickname: nickname)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func signUp() {
        Task {
            do {
                signUpSuccess = try await authService.signup(nickname: nickname, email: email, password: password)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
