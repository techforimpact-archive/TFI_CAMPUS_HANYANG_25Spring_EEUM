import SwiftUI

struct PlaceListCell: View {
    let place: PlaceUIO
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(place.name)
                            .font(.title2)
                            .fontDesign(.rounded)
                            .bold()
                            .foregroundStyle(Color.pink)
                        
                        ForEach(place.categories, id: \.self) { category in
                            PlaceCategoryTag(category: category)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundStyle(Color.pink)
                        
                        Text(place.fullAddress)
                            .foregroundStyle(Color.black)
                    }
                }
                
                Spacer()
                
                Image("chevron_right", bundle: .module)
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            
            Divider()
                .padding(.vertical, 8)
        }
        .padding(.horizontal, 16)
    }
}
