import SwiftUI

enum ContentTab: String {
    case info
    case placeMap
    case placeList
    case user
}

struct ContentView: View {
    @AppStorage("tab") var tab = ContentTab.info
    @AppStorage("qrAuthorized") var qrAuthorized: Bool = false
    
    @State private var authService = AuthService()
    @State private var showOnboarding: Bool = false

    var body: some View {
        TabView(selection: $tab) {
            InfoView()
                .tabItem {
                    Label("띵동", systemImage: "house")
                }
                .tag(ContentTab.info)
            
            placeMapViewTabItem
                .tabItem {
                    #if SKIP
                    Label("장소", systemImage: "Icons.Outlined.Place")
                    #else
                    Label("장소", systemImage: "mappin.and.ellipse")
                    #endif
                }
                .tag(ContentTab.placeMap)
            
            placeListViewTabItem
                .tabItem {
                    Label("목록", systemImage: "list.bullet")
                }
                .tag(ContentTab.placeList)
            
            UserView(qrAuthorized: $qrAuthorized)
                .tabItem {
                    Label("유저", systemImage: "person.crop.circle")
                }
                .tag(ContentTab.user)
        }
        .environment(authService)
        .preferredColorScheme(.light)
        .onAppear {
            if !UserDefaults.standard.bool(forKey: "launchedBefore") {
                showOnboarding = true
            }
            if let email = UserDefaults.standard.string(forKey: "email"), let password = UserDefaults.standard.string(forKey: "password") {
                autoLogin(email: email, password: password)
            }
            authService.qrAuthorized = qrAuthorized
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView(withHeader: false)
        }
        #if os(iOS)
        .sensoryFeedback(.selection, trigger: tab)
        #endif
    }
}

private extension ContentView {
    @ViewBuilder
    var placeMapViewTabItem: some View {
        if authService.userInfo == nil {
            AuthorizationView()
        } else if !authService.qrAuthorized {
            QRAuthorizationAlertView(qrAuthorized: $qrAuthorized)
        } else {
            PlaceMapView()
        }
    }
    
    @ViewBuilder
    var placeListViewTabItem: some View {
        if authService.userInfo == nil {
            AuthorizationView()
        } else if !authService.qrAuthorized {
            QRAuthorizationAlertView(qrAuthorized: $qrAuthorized)
        } else {
            PlaceListView()
        }
    }
}

private extension ContentView {
    func autoLogin(email: String, password: String) {
        Task {
            do {
                _ = try await authService.signin(email: email, password: password)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
