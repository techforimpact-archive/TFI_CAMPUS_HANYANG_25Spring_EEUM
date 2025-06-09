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
            
            if let phone = place.phone {
                HStack(spacing: 8) {
                    Image(systemName: "phone.fill")
                        .foregroundStyle(Color.pink)
                    
                    Text(phone)
                }
            }
            
            if let email = place.email {
                HStack(spacing: 8) {
                    Image(systemName: "envelope.fill")
                        .foregroundStyle(Color.pink)
                    
                    Text(email)
                }
            }
            
            if let website = place.website {
                if let url = URL(string: website) {
                    HStack(spacing: 8) {
                        Image(systemName: "house.fill")
                            .foregroundStyle(Color.pink)
                        
                        NavigationLink {
                            WebpageView(url: url)
                        } label: {
                            Text(website)
                                .foregroundStyle(Color.black)
                        }
                    }
                }
            }
        }
    }
}
