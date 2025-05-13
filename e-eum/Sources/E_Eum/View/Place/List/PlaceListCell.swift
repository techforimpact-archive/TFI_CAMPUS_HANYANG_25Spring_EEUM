import SwiftUI

struct PlaceListCell: View {
    let place: PlaceUIO
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(place.name)
                    .font(.title)
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundStyle(Color.pink)
                
                ForEach(place.categories, id: \.self) { category in
                    PlaceCategoryTag(category: category)
                }
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                Text("주소 : ")
                    .bold()
                
                Text("\(place.province) \(place.city) \(place.district)")
                
                Spacer()
            }
            
            Divider()
                .padding(.vertical, 8)
        }
        .padding(.horizontal, 16)
    }
}
