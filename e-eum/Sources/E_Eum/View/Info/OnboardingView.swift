import SwiftUI

struct OnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    
    let withHeader: Bool
    
    var body: some View {
        VStack {
            if withHeader {
                SheetHeader()
                    .padding(.horizontal, 16)
            }
            
            TabView {
                page(
                    title: "성소수자 청소년을 위한\n따뜻한 공간을 잇다",
                    text: "쉼터와 상담 기관은 물론,\n누구나 편히 머물 수 있는\n카페, 책방, 식당 등의 정보를\n한눈에 찾아볼 수 있어요"
                )
                
                page(
                    title: "성소수자 청소년이\n더 안전한 공간을 찾을 수 있도록",
                    text: "다양한 정보를 나누고 싶은, 그리고\n편히 머물 수 있는 장소를 찾고 싶은\n청소년 성소수자를 위해 만들어졌어요"
                )
                
                page(
                    title: "도움이 필요할 때,\n편히 쉬고 싶을 때, 문화를 나누고 싶을 때",
                    text: "쉼터나 상담이 필요한 청소년,\n안전한 공간을 찾는 사람들,\n그리고 이들을 돕고 싶은 누구나\n사용할 수 있어요"
                )
                
                page(
                    title: "성소수자 청소년을 위한\n안전한 공간을 만들기 위한 서비스",
                    text: "이를 반대하거나, 혐오표현이나\n악의적인 목적으로 이용하려는 사람은\n사용할 수 없어요"
                )
                
                ZStack {
                    page(
                        title: "우리가 함께 만드는 안전한 지도\n당신의 일상과 여정을 함께해요",
                        text: "쉼터, 상담소, 병원은 물론이고,\n 카페, 식당, 책방, 전시 공간 등\n성소수자에게 열려 있는\n다양한 장소들을 쉽게 찾을 수 있어요"
                    )
                    
                    endButton
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            #if os(iOS)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            #endif
        }
    }
}

private extension OnboardingView {
    func page(title: String, text: String) -> some View {
        VStack(alignment: .center, spacing: 32) {
            HStack(alignment: .center) {
                Image("eeum_icon", bundle: .module)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
                
                Image("ddingdong_icon_1", bundle: .module)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
            }
            
            Text(title)
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
            
            Image("speech_bubble", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300)
                .overlay {
                    Text(text)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 32)
                }
            
            Image("character", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
        }
    }
    
    var endButton: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                    dismiss()
                } label: {
                    Circle()
                        .frame(width: 70, height: 70)
                        .foregroundStyle(Color.pink)
                        .overlay {
                            VStack {
                                Image(systemName: "checkmark.circle")
                                    .font(.title)
                                
                                Text("확인했어요")
                                    .font(.caption)
                            }
                            .foregroundStyle(Color.white)
                        }
                }
                .padding(16)
            }
        }
    }
}
