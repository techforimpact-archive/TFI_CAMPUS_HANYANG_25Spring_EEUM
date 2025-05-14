import SwiftUI

struct RainbowColorTitle: View {
    let text: String
    let font: Font
    
    var body: some View {
        Text(text)
            .font(font)
            .fontDesign(.rounded)
            .bold()
            .foregroundStyle(
                LinearGradient(
                    colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}
