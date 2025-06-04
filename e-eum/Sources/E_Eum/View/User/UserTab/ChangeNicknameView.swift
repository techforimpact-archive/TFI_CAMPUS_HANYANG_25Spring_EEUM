import SwiftUI

struct ChangeNicknameView: View {
    @Environment(AuthService.self) private var authService
    @Environment(\.dismiss) private var dismiss
    
    @State private var newNickname: String = ""
    @State private var nicknameVerified: Bool?
    @State private var showNicknameChangedAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                AuthorizationTextField(input: $newNickname, placeholder: "닉네임을 입력해주세요.")
                
                Button {
                    checkNickname()
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 120, height: 50)
                        .foregroundStyle(nicknameVerified == nil ? Color.pink : nicknameVerified! ? Color.green : Color.red)
                        .overlay {
                            Text(nicknameVerified == nil ? "중복 확인" : nicknameVerified! ? "사용 가능" : "닉네임 중복")
                                .foregroundStyle(Color.white)
                        }
                }
                .disabled(newNickname.isEmpty)
            }
            .onChange(of: newNickname) {
                nicknameVerified = nil
            }
            
            BasicButton(title: "닉네임 변경하기", disabled: .constant(nicknameVerified != true)) {
                changeNickname()
                authService.userInfo?.nickname = newNickname
                showNicknameChangedAlert = true
            }
            
            Spacer()
        }
        .padding(16)
        .alert("닉네임 변경", isPresented: $showNicknameChangedAlert) {
            Button {
                dismiss()
            } label: {
                Text("확인")
            }
        } message: {
            Text("닉네임이 변경되었습니다.")
        }
    }
}

private extension ChangeNicknameView {
    func checkNickname() {
        Task {
            do {
                nicknameVerified = try await authService.checkNickname(nickname: newNickname)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func changeNickname() {
        Task {
            do {
                _ = try await authService.changeNickname(nickname: newNickname)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
