import SwiftUI

/// A view that shows a blue heart on iOS and a green heart on Android.
struct PlatformHeartView: View {
    var body: some View {
       #if SKIP
       ComposeView { ctx in // Mix in Compose code!
           androidx.compose.material3.Text("💚", modifier: ctx.modifier)
       }
       #else
       Text(verbatim: "💙")
       #endif
    }
}
