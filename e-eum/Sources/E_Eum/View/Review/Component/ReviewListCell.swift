import SwiftUI

struct ReviewListCell: View {
    @Environment(\.dismiss) private var dismiss
    
    let review: ReviewUIO
    
    @State private var reviewService = ReviewService()
    @State private var showReviewActionSheet: Bool = false
    @State private var showReportAlert: Bool = false
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .center, spacing: 8) {
                Image("user_image", bundle: .module)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                
                Button {
                    showReviewActionSheet = true
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(Color.gray)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Text(review.userNickname)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(Color.black)
                    
                    Spacer()
                    
                    Text(review.createdAt.prefix(10))
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                }
                
                HStack(alignment: .top, spacing: 8) {
                    #if !SKIP
                    if let content = review.content {
                        Text(content)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.black)
                    }
                    
                    Spacer()
                    #endif
                    
                    if let imageUrl = review.imageUrls.first {
                        AsyncImage(url: URL(string: imageUrl)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } placeholder: {
                            ProgressView()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(Color.pink)
                        }
                    }
                    
                    #if SKIP
                    if let content = review.content {
                        Text(content)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(Color.black)
                    }
                    #endif
                }
            }
            .padding()
            .foregroundStyle(Color.black)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundStyle(Color.pink)
            }
        }
        .confirmationDialog("신고사유를 선택해주세요.", isPresented: $showReviewActionSheet) {
            Button {
                reportReview(reportType: .incorrectInfo)
            } label: {
                Text("잘못된 정보")
            }

            Button {
                reportReview(reportType: .commercialAd)
            } label: {
                Text("상업적 광고")
            }
            
            Button {
                reportReview(reportType: .spam)
            } label: {
                Text("음란물")
            }
            
            Button {
                reportReview(reportType: .profanity)
            } label: {
                Text("폭력성")
            }
            
            Button {
                reportReview(reportType: .other)
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
        .sensoryFeedback(.selection, trigger: showReviewActionSheet)
        .sensoryFeedback(.success, trigger: showReportAlert)
        #endif
    }
}

private extension ReviewListCell {
    func reportReview(reportType: ReportType) {
        Task {
            do {
                showReportAlert = try await reviewService.reportReview(reviewID: review.id, contentType: ContentType.review, reportType: reportType)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
