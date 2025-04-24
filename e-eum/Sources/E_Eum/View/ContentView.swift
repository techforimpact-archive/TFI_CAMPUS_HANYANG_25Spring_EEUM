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
                .tabItem { Label("띵동", systemImage: "house.fill") }
                .tag(ContentTab.info)
            
            PlaceView()
                .tabItem { Label("지도", systemImage: "map.fill") }
                .tag(ContentTab.place)
        }
        .preferredColorScheme(.light)
    }
}
