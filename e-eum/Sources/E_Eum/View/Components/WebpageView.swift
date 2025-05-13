import SwiftUI
import SkipWeb

struct WebpageView: View {
    let url: URL
    
    var body: some View {
        WebView(url: url)
    }
}
