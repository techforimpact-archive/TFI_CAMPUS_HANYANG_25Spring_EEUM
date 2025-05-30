import SwiftUI

struct AuthorizationSecureField: View {
    @Binding var input: String
    let placeholder: String
    
    var body: some View {
        SecureField(text: $input) {
            Text(placeholder)
        }
        .submitLabel(.done)
        #if !SKIP
        .padding()
        .frame(height: 50)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: 2))
                .foregroundColor(Color.pink)
        }
        #endif
    }
}
