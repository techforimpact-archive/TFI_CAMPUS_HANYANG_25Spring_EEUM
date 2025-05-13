import SwiftUI

struct BasicButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.title3)
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.pink)
                )
        }
    }
}
