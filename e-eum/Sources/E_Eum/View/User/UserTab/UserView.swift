import SwiftUI

struct UserView: View {
    @Environment(AuthService.self) private var authService
    @Environment(\.openURL) var openURL
    
    @Binding var qrAuthorized: Bool
    
    @State private var showOnboarding: Bool = false
    @State private var showSignOutAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 8) {
                header
                
                Button {
                    showOnboarding = true
                } label: {
                    HStack(spacing: 0) {
                        Image("character", bundle: .module)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                        
                        Image("speech_bubble_2", bundle: .module)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .overlay {
                                Text("\"어디에 있든\n당신이 편히 머물 수 있는 곳이\n있다는 것을 잊지 마세요.\"")
                                    .bold()
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(Color.black)
                                    .padding(.leading, 24)
                            }
                    }
                    .padding(.vertical, 0)
                }
                .fullScreenCover(isPresented: $showOnboarding) {
                    OnboardingView(withHeader: true)
                }
                
                if let nickname = authService.userInfo?.nickname {
                    Text(nickname)
                        .font(.title2)
                        .bold()
                } else {
                    Text("안녕하세요.")
                        .font(.title2)
                        .bold()
                }
                
                Divider()
                
                if authService.userInfo != nil {
                    NavigationLink {
                        UserFavoritesAndReviewsView()
                    } label: {
                        UserViewMenuCell(title: "나의 저장 목록 및 리뷰")
                    }
                    
                    NavigationLink {
                        UserInfoView(qrAuthorized: $qrAuthorized)
                    } label: {
                        UserViewMenuCell(title: "내 정보 수정")
                    }
                }
                
                NavigationLink {
                    DocumentView(title: "서비스 이용약관", text: termsOfUse())
                } label: {
                    UserViewMenuCell(title: "서비스 이용약관")
                }
                
                NavigationLink {
                    DocumentView(title: "개인정보 처리방침", text: privacyPolicy())
                } label: {
                    UserViewMenuCell(title: "개인정보 처리방침")
                }
                
                Button {
                    send(openURL: openURL)
                } label: {
                    UserViewMenuCell(title: "1:1 문의 및 개선 제안")
                }
                
                if authService.userInfo != nil {
                    Button {
                        showSignOutAlert = true
                    } label: {
                        UserViewMenuCell(title: "로그아웃")
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .alert("로그아웃", isPresented: $showSignOutAlert, actions: {
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
            }, message: {
                Text("정말 로그아웃 하시겠어요?")
            })
            #if os(iOS)
            .sensoryFeedback(.warning, trigger: showSignOutAlert)
            #endif
        }
    }
}

private extension UserView {
    var header: some View {
        HStack {
            RainbowColorTitle(text: "마이페이지", font: .largeTitle)
            
            Spacer()
            
            Image("eeum_icon", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
        }
    }
}

private extension UserView {
    func send(openURL: OpenURLAction) {
        let feedbackEmail = FeedbackEmail()
        let urlString = "mailto:\(feedbackEmail.email)?subject=\(feedbackEmail.subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(feedbackEmail.body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        
        guard let url = URL(string: urlString) else { return }
        openURL.callAsFunction(url)
    }
    
    private struct FeedbackEmail {
        let email = "eeum.tech@gmail.com"
        let subject = "제목을 입력해주세요."
        let body = "내용을 입력해주세요.\n\n여러분의 피드백은 더 나은 '이음' 개발에 활용됩니다."
    }
    
    func termsOfUse() -> String {
        guard let filePath = Bundle.module.url(forResource: "TermsOfUse", withExtension: "txt") else {
            return "서비스 이용약관 문서가 존재하지 않습니다."
        }
        
        do {
            return try String(contentsOf: filePath, encoding: .utf8)
        } catch {
            return "서비스 이용약관을 불러오는 과정에서 오류가 발생했습니다."
        }
    }
    
    func privacyPolicy() -> String {
        guard let filePath = Bundle.module.url(forResource: "PrivacyPolicy", withExtension: "txt") else {
            return "개인정보 처리방침 문서가 존재하지 않습니다."
        }
        
        do {
            return try String(contentsOf: filePath, encoding: .utf8)
        } catch {
            return "개인정보 처리방침을 불러오는 과정에서 오류가 발생했습니다."
        }
    }
    
    func signOut() {
        Task {
            do {
                let result = try await authService.signout()
                if result {
                    qrAuthorized = false
                    UserDefaults.standard.removeObject(forKey: "email")
                    UserDefaults.standard.removeObject(forKey: "password")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
