import SwiftUI

struct PlaceCategoryAllTag: View {
    var body: some View {
        Text("전체")
            .padding(4)
            .foregroundStyle(Color.black)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .background(Color.white)
            }
    }
}
