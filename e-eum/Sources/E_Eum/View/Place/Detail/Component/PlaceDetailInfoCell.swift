import SwiftUI

struct PlaceDetailInfoCell: View {
    let place: PlaceDetailUIO
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundStyle(Color.pink)
                
                Text(place.fullAddress)
            }
            
            HStack(spacing: 8) {
                Image(systemName: "phone.fill")
                    .foregroundStyle(Color.pink)
                
                Text(place.phone)
            }
            
            HStack(spacing: 8) {
                Image(systemName: "envelope.fill")
                    .foregroundStyle(Color.pink)
                
                Text(place.email)
            }
            
            if let url = URL(string: place.website) {
                HStack(spacing: 8) {
                    Image(systemName: "house.fill")
                        .foregroundStyle(Color.pink)
                    
                    NavigationLink {
                        WebpageView(url: url)
                    } label: {
                        Text(place.website)
                            .foregroundStyle(Color.black)
                    }
                }
            }
        }
    }
}
