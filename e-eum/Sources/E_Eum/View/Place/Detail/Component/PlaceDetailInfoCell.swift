import SwiftUI

struct PlaceDetailInfoCell: View {
    let place: PlaceDetailUIO
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 0) {
                Text("주소 : ")
                    .bold()
                
                Text(place.fullAddress)
            }
            
            HStack(spacing: 0) {
                Text("연락처 : ")
                    .bold()
                
                Text(place.phone)
            }
            
            HStack(spacing: 0) {
                Text("이메일 : ")
                    .bold()
                
                Text(place.email)
            }
            
            HStack(spacing: 0) {
                Text("홈페이지 : ")
                    .bold()
                
                Text("[\(place.name)](\(place.website))")
            }
        }
    }
}
