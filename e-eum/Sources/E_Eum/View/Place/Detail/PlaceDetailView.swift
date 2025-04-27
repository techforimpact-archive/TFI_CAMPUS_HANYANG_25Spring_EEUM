import SwiftUI

struct PlaceDetailView: View {
    let place: PlaceDetailUIO = PlaceDetailUIO.sample
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image("sample")
                    .resizable()
                    .scaledToFit()
                
                HStack {
                    Text(place.categories[0])
                        .foregroundStyle(Color.white)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Color.pink)
                        }
                    
                    Text(place.name)
                        .font(.title)
                        .fontDesign(.rounded)
                        .bold()
                        .foregroundStyle(Color.pink)
                }
                
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
            }
            .padding()
        }
    }
}

#Preview {
    PlaceDetailView()
}
