import SwiftUI

struct PlaceDetailTitleCell: View {
    let place: PlaceDetailUIO
    
    var body: some View {
        HStack(alignment: .top) {
            RainbowColorTitle(text: place.name, font: .title)
            
            ForEach(place.categories, id: \.self) { category in
                PlaceCategoryTag(category: category)
            }
            
            Spacer()
        }
    }
}
