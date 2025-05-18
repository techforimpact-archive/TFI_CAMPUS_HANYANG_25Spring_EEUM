import SwiftUI

struct PlaceListCell: View {
    let place: PlaceUIO
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(place.name)
                    .font(.title2)
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundStyle(Color.pink)
                
                ForEach(place.categories, id: \.self) { category in
                    PlaceCategoryTag(category: category)
                }
                
                Spacer()
            }
            
            HStack {
                Image(systemName: "location.fill")
                
                Text(place.fullAddress)
                
                Spacer()
            }
            
            Divider()
                .padding(.vertical, 8)
        }
        .padding(.horizontal, 16)
        .background(Color.white)
    }
}
