import SwiftUI
import SkipWeb

struct DdingdongView: View {
    let url: URL = URL(string: "https://ddingdong.kr/")!
    
    var body: some View {
        WebView(url: url)
    }
}
