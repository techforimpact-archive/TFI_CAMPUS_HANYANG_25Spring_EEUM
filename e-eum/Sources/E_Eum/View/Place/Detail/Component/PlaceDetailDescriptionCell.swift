import SwiftUI

struct PlaceDetailDescriptionCell: View {
    let place: PlaceDetailUIO
    
    var body: some View {
        Text(place.description)
            .multilineTextAlignment(.leading)
            .padding(4)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundStyle(Color.pink)
            }
    }
}
