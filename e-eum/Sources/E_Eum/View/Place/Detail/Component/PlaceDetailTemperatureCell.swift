import SwiftUI

struct PlaceDetailTemperatureCell: View {
    let place: PlaceDetailUIO
    
    private let minTemperature: Double = 0.0
    private let maxTemperature: Double = 50.0
    
    var body: some View {
        VStack {
            HStack {
                Text("이음 온도")
                    .bold()
                
                Spacer()
                
                Text(String(format: "%.1f°C", place.temperature))
                    .font(.title3)
                    .bold()
                    .foregroundStyle(Color.pink)
            }
            
            Capsule()
                .frame(width: 360, height: 20)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .overlay {
                    HStack {
                        Capsule()
                            .frame(width: 360 * CGFloat(place.temperature / (maxTemperature - minTemperature)), height: 20)
                            .foregroundStyle(Color.clear)
                            .overlay {
                                HStack {
                                    Spacer()
                                    
                                    Circle()
                                        .stroke(lineWidth: 4)
                                        .foregroundStyle(Color.white)
                                        .background(Color.pink)
                                        .clipShape(Circle())
                                }
                            }
                        
                        Spacer()
                    }
                }
        }
    }
}
