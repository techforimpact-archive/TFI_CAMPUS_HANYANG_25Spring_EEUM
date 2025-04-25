import SwiftUI

enum ContentTab: String {
    case info
    case place
}

struct ContentView: View {
    @AppStorage("tab") var tab = ContentTab.info

    var body: some View {
        TabView(selection: $tab) {
            InfoView()
                .tabItem {
                    Label("띵동", systemImage: "house")
                }
                .tag(ContentTab.info)
            
            PlaceView()
                .tabItem {
                    #if SKIP
                    Label("장소", systemImage: "Icons.Outlined.Place")
                    #else
                    Label("장소", systemImage: "mappin.and.ellipse")
                    #endif
                }
                .tag(ContentTab.place)
        }
        .preferredColorScheme(.light)
    }
}
