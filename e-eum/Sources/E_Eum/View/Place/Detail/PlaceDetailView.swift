import SwiftUI

struct PlaceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let placeID: String
    
    @State private var placeService = PlaceService()
    @State private var place: PlaceDetailUIO?
    @State private var reviews: [ReviewUIO] = []
    @State private var showPlaceActionSheet: Bool = false
    @State private var showReportAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            if let place = place {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        PlaceDetailReviewImagesCell(imageUrls: place.imageUrls)
                        
                        PlaceDetailTitleCell(place: place)
                        
                        Divider()
                        
                        PlaceDetailInfoCell(place: place)
                        
                        Divider()
                        
                        PlaceDetailTemperatureCell(temperature: place.temperature)
                        
                        Divider()
                        
                        PlaceDetailDescriptionCell(place: place)
                        
                        Divider()
                        
                        ReviewPreviewCell(placeID: placeID, reviews: $reviews)
                    }
                }
            } else {
                ProgressView()
            }
        }
        .padding()
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                if let place = place {
                    if place.favorite {
                        Button {
                            cancelFavoritePlace()
                        } label: {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(Color.red)
                        }
                    } else {
                        Button {
                            addFavoritePlace()
                        } label: {
                            Image(systemName: "heart")
                                .foregroundStyle(Color.red)
                        }
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showPlaceActionSheet = true
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.pink)
                }
            }
        })
        .onAppear {
            loadPlaceInfoAndReviews()
        }
        .confirmationDialog("신고사유를 선택해주세요.", isPresented: $showPlaceActionSheet) {
            Button {
                reportPlace(reportType: .incorrectInfo)
            } label: {
                Text("잘못된 정보")
            }

            Button {
                reportPlace(reportType: .commercialAd)
            } label: {
                Text("상업적 광고")
            }
            
            Button {
                reportPlace(reportType: .spam)
            } label: {
                Text("음란물")
            }
            
            Button {
                reportPlace(reportType: .profanity)
            } label: {
                Text("폭력성")
            }
            
            Button {
                reportPlace(reportType: .other)
            } label: {
                Text("기타")
            }
        } message: {
            Text("신고 검토 후 해당 한줄평에 대한 조치가 진행됩니다.\n누적 신고횟수가 3회 이상인 유저는 한줄평을 작성을 할 수 없게 됩니다.")
        }
        .alert("신고가 접수되었습니다.\n검토까지는 최대 24시간 소요됩니다.", isPresented: $showReportAlert) {
            Button {
            } label: {
                Text("확인")
            }
        }
        #if os(iOS)
        .sensoryFeedback(.impact(weight: .medium), trigger: place?.favorite)
        #endif
    }
}

private extension PlaceDetailView {
    func loadPlaceInfoAndReviews() {
        Task {
            do {
                place = try await placeService.getPlaceDetails(placeID: placeID)
                reviews = try await placeService.getPlaceReviews(placeID: placeID, lastID: "", size: 5, sortBy: "rating", sortDirection: "DESC").reviews
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addFavoritePlace() {
        Task {
            do {
                place?.favorite = try await placeService.addFavoritePlace(placeID: placeID)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func cancelFavoritePlace() {
        Task {
            do {
                place?.favorite = try await !placeService.cancelFavoritePlace(placeID: placeID)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func reportPlace(reportType: ReportType) {
        Task {
            do {
                showReportAlert = try await placeService.reportPlace(placeID: placeID, contentType: ContentType.place, reportType: reportType)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
