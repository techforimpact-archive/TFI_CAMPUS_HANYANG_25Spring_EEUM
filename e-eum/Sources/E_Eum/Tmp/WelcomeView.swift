import SwiftUI

struct WelcomeView: View {
    @State var heartBeating = false
    @Binding var welcomeName: String

    var body: some View {
        VStack(spacing: 0) {
            Text("Hello [\(welcomeName)](https://skip.tools)!")
                .padding()
            Image(systemName: "heart.fill")
                .foregroundStyle(.red)
                .scaleEffect(heartBeating ? 1.5 : 1.0)
                .animation(.easeInOut(duration: 1).repeatForever(), value: heartBeating)
                .onAppear { heartBeating = true }
        }
        .font(.largeTitle)
    }
}
