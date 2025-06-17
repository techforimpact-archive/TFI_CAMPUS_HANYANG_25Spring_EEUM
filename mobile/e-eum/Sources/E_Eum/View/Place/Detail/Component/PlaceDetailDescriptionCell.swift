import SwiftUI

struct PlaceDetailDescriptionCell: View {
    let place: PlaceDetailUIO
    
    var body: some View {
        Text(place.description)
            .multilineTextAlignment(.leading)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
    }
}
