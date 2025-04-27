import SwiftUI

struct PlaceListCell: View {
    let place: PlaceUIO
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(place.name)
                    .font(.title)
                    .fontDesign(.rounded)
                    .bold()
                    .foregroundStyle(Color.pink)
                
                HStack(spacing: 0) {
                    Text("주소 : ")
                        .bold()
                    
                    Text("\(place.province) \(place.city) \(place.district)")
                }
                
                HStack {
                    ForEach(place.categories, id: \.self) { category in
                        Text(category)
                            .foregroundStyle(Color.white)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color.pink)
                            }
                    }
                }
            }
            
            Spacer()
        }
        .padding(16)
    }
}
