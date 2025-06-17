import SwiftUI

struct UserInfoView: View {
    @Environment(AuthService.self) private var authService
    
    @Binding var qrAuthorized: Bool
    
    @State private var showDeactivateAlert: Bool = false
    
    var body: some View {
        VStack {
            if let userInfo = authService.userInfo {
                NavigationLink {
                    ChangeNicknameView()
                } label: {
                    userInfoCell(title: "닉네임", value: userInfo.nickname)
                }

                NavigationLink {
                    ChangePasswordView()
                } label: {
                    userInfoCell(title: "비밀번호", value: "********")
                }
            }
            
            Spacer()
            
            if authService.userInfo != nil {
                Button {
                    showDeactivateAlert = true
                } label: {
                    Text("회원탈퇴")
                        .underline()
                        .foregroundStyle(Color.gray)
                }
            }
        }
        .padding(16)
        .navigationTitle("내 정보 수정")
        .alert("회원탈퇴", isPresented: $showDeactivateAlert, actions: {
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
        }, message: {
            Text("정말 회원탈퇴 하시겠어요?")
        })
        #if os(iOS)
        .sensoryFeedback(.warning, trigger: showDeactivateAlert)
        #endif
    }
}

private extension UserInfoView {
    func userInfoCell(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.title3)
                .foregroundStyle(Color.black)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .foregroundStyle(Color.black)
            
            Image("chevron_right", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
        }
        .padding(.vertical, 16)
    }
}

private extension UserInfoView {
    func deactivate() {
        Task {
            do {
                _ = try await authService.deactivate()
                authService.userInfo = nil
                authService.qrAuthorized = false
                qrAuthorized = false
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "password")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
