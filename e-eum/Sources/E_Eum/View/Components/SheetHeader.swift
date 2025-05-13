import SwiftUI

struct SheetHeader: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack(alignment: .top) {
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(Color.pink)
            }
        }
    }
}
