import SwiftUI

struct PlaceDetailTitleCell: View {
    let place: PlaceDetailUIO
    
    var body: some View {
        HStack {
            PlaceCategoryTag(category: place.categories[0])
            
            Text(place.name)
                .font(.title)
                .fontDesign(.rounded)
                .bold()
                .foregroundStyle(Color.pink)
        }
    }
}
