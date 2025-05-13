import SwiftUI

struct PlaceDetailTitleCell: View {
    let place: PlaceDetailUIO
    
    var body: some View {
        HStack {
            RainbowColorTitle(text: place.name, font: .title)
            
            PlaceCategoryTag(category: place.categories[0])
            
            Spacer()
        }
    }
}
