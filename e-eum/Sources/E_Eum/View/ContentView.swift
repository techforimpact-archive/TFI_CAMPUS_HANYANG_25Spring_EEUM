import SwiftUI

enum ContentTab: String, Hashable {
    case welcome, home, settings
}

struct ContentView: View {
    @AppStorage("tab") var tab = ContentTab.welcome
    @AppStorage("name") var welcomeName = "Skipper"
    @AppStorage("appearance") var appearance = ""
    @State var viewModel = ViewModel()

    var body: some View {
        TabView(selection: $tab) {
            NavigationStack {
                WelcomeView(welcomeName: $welcomeName)
            }
            .tabItem { Label("Welcome", systemImage: "heart.fill") }
            .tag(ContentTab.welcome)

            NavigationStack {
                ItemListView()
                    .navigationTitle(Text("\(viewModel.items.count) Items"))
            }
            .tabItem { Label("Home", systemImage: "house.fill") }
            .tag(ContentTab.home)

            NavigationStack {
                SettingsView(appearance: $appearance, welcomeName: $welcomeName)
                    .navigationTitle("Settings")
            }
            .tabItem { Label("Settings", systemImage: "gearshape.fill") }
            .tag(ContentTab.settings)
        }
        .environment(viewModel)
        .preferredColorScheme(appearance == "dark" ? .dark : appearance == "light" ? .light : nil)
    }
}
