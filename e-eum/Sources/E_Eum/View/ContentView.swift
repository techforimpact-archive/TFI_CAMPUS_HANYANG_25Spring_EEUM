import SwiftUI

enum ContentTab: String {
    case info
    case placeMap
    case placeList
    case user
}

struct ContentView: View {
    @AppStorage("tab") var tab = ContentTab.info
    
    @State private var authService = AuthService()

    var body: some View {
        TabView(selection: $tab) {
            InfoView()
                .tabItem {
                    Label("띵동", systemImage: "house")
                }
                .tag(ContentTab.info)
            
            if authService.qrAuthorized {
                PlaceMapView()
                    .tabItem {
                        #if SKIP
                        Label("장소", systemImage: "Icons.Outlined.Place")
                        #else
                        Label("장소", systemImage: "mappin.and.ellipse")
                        #endif
                    }
                    .tag(ContentTab.placeMap)
                
                PlaceListView()
                    .tabItem {
                        Label("목록", systemImage: "list.bullet")
                    }
                    .tag(ContentTab.placeList)
            } else {
                QRAuthorizationAlertView()
                    .tabItem {
                        #if SKIP
                        Label("장소", systemImage: "Icons.Outlined.Place")
                        #else
                        Label("장소", systemImage: "mappin.and.ellipse")
                        #endif
                    }
                    .tag(ContentTab.placeMap)
                
                QRAuthorizationAlertView()
                    .tabItem {
                        Label("목록", systemImage: "list.bullet")
                    }
                    .tag(ContentTab.placeList)
            }
            
            UserView()
                .tabItem {
                    Label("유저", systemImage: "person.crop.circle")
                }
                .tag(ContentTab.user)
        }
        .environment(authService)
        .preferredColorScheme(.light)
    }
}
