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
            authService.qrAuthorized = qrAuthorized
        }
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
