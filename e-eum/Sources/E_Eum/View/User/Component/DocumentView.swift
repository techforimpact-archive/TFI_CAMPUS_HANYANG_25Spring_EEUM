import SwiftUI

struct DocumentView: View {
    let title: String
    let text: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            TextEditor(text: .constant(text))
                .scrollContentBackground(.hidden)
                .focused($isFocused)
                .onChange(of: isFocused, {
                    isFocused = false
                })
                .foregroundStyle(Color.black)
                .padding(.horizontal, 16)
        }
        .navigationTitle(title)
    }
}
