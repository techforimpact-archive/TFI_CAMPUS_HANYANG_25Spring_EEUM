import SwiftUI

struct PlaceDetailView: View {
    @Binding var placeID: String
    
    @State private var placeService = PlaceService()
    @State private var place: PlaceDetailUIO?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PlaceDetailHeader()
            
            if let place = place {
                Image("sample")
                    .resizable()
                    .scaledToFit()
                
                PlaceDetailTitleCell(place: place)
                
                HStack(spacing: 0) {
                    Text("주소 : ")
                        .bold()
                    
                    Text("\(place.province) \(place.city) \(place.district)")
                }
                
                HStack(spacing: 0) {
                    Text("연락처 : ")
                        .bold()
                    
                    Text("\(place.phone)")
                }
                
                HStack(spacing: 0) {
                    Text("이메일 : ")
                        .bold()
                    
                    Text("\(place.email)")
                }
                
                HStack(spacing: 0) {
                    Text("홈페이지 : ")
                        .bold()
                    
                    Text("[\(place.name)](\(place.website))")
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
                
                Text("퀴어 온도")
                    .bold()
                
                Slider(value: .constant(place.temperature), in: 0...10) {
                    Text("dd")
                }
                .disabled(true)
                .tint(Color.pink)
                
                Text(place.description)
                    .multilineTextAlignment(.leading)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle(lineWidth: 1))
                            .foregroundStyle(Color.pink)
                    }
            } else {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding()
        .task {
            do {
                place = try await placeService.getPlaceDetails(placeID: placeID)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
