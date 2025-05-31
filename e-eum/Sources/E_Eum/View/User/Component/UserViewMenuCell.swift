import SwiftUI

struct UserViewMenuCell: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .foregroundStyle(Color.black)
            
            Spacer()
            
            Image("chevron_right", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
        }
        .padding(.vertical, 16)
    }
}
