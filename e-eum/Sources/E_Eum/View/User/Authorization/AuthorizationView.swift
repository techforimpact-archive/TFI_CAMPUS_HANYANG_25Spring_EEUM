import SwiftUI

enum ViewType {
    case signup
    case signin
}

struct AuthorizationView: View {
    @Environment(AuthService.self) private var authService
    
    @State private var viewType: ViewType = .signin
    
    var body: some View {
        VStack(alignment: .center, spacing: 32) {
            Image("ddingdong_icon_1", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
            
            viewSelectArea
            
            switch viewType {
            case .signup:
                SignUpView(viewType: $viewType)
            case .signin:
                SignInView()
            }
        }
        .padding(16)
        #if os(iOS)
        .sensoryFeedback(.selection, trigger: viewType)
        #endif
    }
}

private extension AuthorizationView {
    var viewSelectArea: some View {
        HStack {
            Button {
                viewType = .signup
            } label: {
                Text("회원가입")
                    .bold(viewType == .signup)
                    .foregroundStyle(viewType == .signup ? Color.pink : Color.black)
            }

            Text("|")
            
            Button {
                viewType = .signin
            } label: {
                Text("로그인")
                    .bold(viewType == .signin)
                    .foregroundStyle(viewType == .signin ? Color.pink : Color.black)
            }
        }
        .font(.title3)
    }
}
