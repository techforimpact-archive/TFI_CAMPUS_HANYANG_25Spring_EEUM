import SwiftUI

enum WebpageLink: String {
    case withDDingdong = "https://pf.kakao.com/_AHndV"
    case placeRecommendation = "https://forms.gle/u3NQ3oQ5sEP2NZw17"
    case techForImpact = "https://techforimpact.io/campus/info"
}

struct InfoView: View {
    @Environment(AuthService.self) private var authService
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    Color.pink.opacity(0.6)
                    
                    Color.white
                }
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 16) {
                    Image("eeum_icon", bundle: .module)
                        .resizable()
                        .frame(width: 70, height: 70)
                        .padding(.horizontal, 16)
                    
                    if let userInfo = authService.userInfo {
                        Text("Hi \(userInfo.nickname)!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(Color.white)
                            .padding(16)
                    } else {
                        Text("반가워요:)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(Color.white)
                            .padding(16)
                    }
                    
                    HStack(spacing: 16) {
                        NavigationLink {
                            ScrollView {
                                Image("ddingdongInfo", bundle: .module)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        } label: {
                            cardButton {
                                VStack(alignment: .center) {
                                    Image("ddingdong_icon_1", bundle: .module)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 120)
                                    
                                    Text("띵동을\n알고싶어?")
                                        .font(.title2)
                                        .bold()
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(Color.black)
                                }
                            }
                        }
                        
                        NavigationLink {
                            WebpageView(url: URL(string: WebpageLink.withDDingdong.rawValue)!)
                        } label: {
                            cardButton {
                                VStack(alignment: .center) {
                                    Image("character", bundle: .module)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100)
                                    
                                    Text("띵동과\n함께하고 싶다면?")
                                        .font(.title2)
                                        .bold()
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(Color.black)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    HStack(spacing: 16) {
                        NavigationLink {
                            WebpageView(url: URL(string: WebpageLink.placeRecommendation.rawValue)!)
                        } label: {
                            cardButton {
                                VStack(alignment: .center) {
                                    Image("rainbow", bundle: .module)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 140)
                                    
                                    Spacer()
                                    
                                    Text("퀴어들의\n장소를 추천해줘!")
                                        .font(.title2)
                                        .bold()
                                        .multilineTextAlignment(.leading)
                                        .foregroundStyle(Color.black)
                                    
                                    Spacer()
                                }
                            }
                        }
                        
                        NavigationLink {
                            WebpageView(url: URL(string: WebpageLink.techForImpact.rawValue)!)
                        } label: {
                            cardButton {
                                VStack(alignment: .center, spacing: 24) {
                                    Image("ddingdong_icon_2", bundle: .module)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 110)
                                    
                                    Image("hyu_icon", bundle: .module)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 110)
                                    
                                    Image("kakaoimpact_icon", bundle: .module)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 110)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 40, trailing: 16))
            }
        }
    }
}

private extension InfoView {
    func cardButton<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(style: StrokeStyle(lineWidth: 2))
            .frame(width: 160, height: 200)
            .foregroundStyle(Color.pink)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.white)
                    .shadow(color: .gray, radius: 0.5, y: 5)
            )
            .overlay {
                content()
            }
    }
}
