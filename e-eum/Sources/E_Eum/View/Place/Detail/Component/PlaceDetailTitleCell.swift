import SwiftUI

struct PlaceDetailTitleCell: View {
    let place: PlaceDetailUIO
    
    var body: some View {
        HStack {
            Text(place.categories[0])
                .foregroundStyle(Color.white)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.pink)
                }
            
            Text(place.name)
                .font(.title)
                .fontDesign(.rounded)
                .bold()
                .foregroundStyle(Color.pink)
        }
    }
}
