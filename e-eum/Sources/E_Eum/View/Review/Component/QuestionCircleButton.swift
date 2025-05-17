import SwiftUI

struct QuestionCircleButton: View {
    let text: String
    @Binding var currentQuestionIndex: Int
    let action: () -> Void
    
    @State private var scaleAnimation: Bool = false
    
    var body: some View {
        Button {
            scaleAnimation = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                scaleAnimation = false
                currentQuestionIndex += 1
            }
            
            action()
        } label: {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundStyle(scaleAnimation ? Color.pink : Color.gray)
                .overlay {
                    Text(text)
                        .bold()
                        .foregroundStyle(Color.white)
                }
        }
        .scaleEffect(scaleAnimation ? 1.5 : 1.0)
        .animation(.spring(), value: scaleAnimation)
    }
}
