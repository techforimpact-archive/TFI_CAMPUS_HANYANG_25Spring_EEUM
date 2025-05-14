import SwiftUI

struct InfoView: View {
    let url: URL = URL(string: "https://ddingdong.kr/")!
    
    var body: some View {
        WebpageView(url: url)
    }
}
