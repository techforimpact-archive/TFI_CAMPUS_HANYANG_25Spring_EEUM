import SwiftUI

enum ContentTab: String, Hashable {
    case ddingdong, home, settings
}

struct ContentView: View {
    @AppStorage("tab") var tab = ContentTab.ddingdong
    @AppStorage("name") var welcomeName = "Skipper"
    @AppStorage("appearance") var appearance = ""
    @State var viewModel = ViewModel()

    var body: some View {
        TabView(selection: $tab) {
            NavigationStack {
                DdingdongView()
            }
            .tabItem { Label("띵동", systemImage: "house.fill") }
            .tag(ContentTab.ddingdong)

            NavigationStack {
                ItemListView()
                    .navigationTitle(Text("\(viewModel.items.count) Items"))
            }
            .tabItem { Label("지도", systemImage: "map.fill") }
            .tag(ContentTab.home)

            NavigationStack {
                SettingsView(appearance: $appearance, welcomeName: $welcomeName)
                    .navigationTitle("Settings")
            }
            .tabItem { Label("설정", systemImage: "gearshape.fill") }
            .tag(ContentTab.settings)
        }
        .environment(viewModel)
        .preferredColorScheme(.light)
    }
}
