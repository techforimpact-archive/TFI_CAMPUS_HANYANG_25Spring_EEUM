import SwiftUI
import SkipKit
import UIKit

struct ReviewCreateView: View {
    @Environment(\.dismiss) private var dismiss
    
    let placeId: String
    
    let type: MediaPickerType = .library
    
    @State private var placeService = PlaceService()
    @State private var reviewService = ReviewService()
    @State private var questions: [QuestionUIO] = [QuestionUIO(id: "first", question: "해당 장소는 어떠셨나요?")]
    @State private var currentQuestionIndex: Int = 0
    @State private var buttonDisabled: Bool = true
    @State private var content: String = ""
    @State private var ratings: Dictionary<String, Int> = [:]
    @State private var recommended: Bool = false
    @State private var showImagePicker = false
    @State private var selectedImageURL: URL?
    @State private var selectedUIImage: UIImage?
    @State private var showReviewCreatedAlert: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Text("\(currentQuestionIndex + 1) / \(questions.count)")
                .animation(.bouncy(duration: 1), value: currentQuestionIndex)
                
            questionCell(question: questions[currentQuestionIndex])
                .animation(.bouncy(duration: 1), value: currentQuestionIndex)
            
            Spacer()
            
            BasicButton(title: "한줄평 작성하기", disabled: $buttonDisabled) {
                Task {
                    do {
                        if let selectedUIImage = selectedUIImage {
                            _ = try await placeService.createPlaceReview(placeID: placeId, content: content, ratings: ratings, recommended: recommended, image: selectedUIImage)
                        }
                        showReviewCreatedAlert = true
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            .padding(16)
        }
        .task {
            do {
                questions.append(contentsOf: try await reviewService.getQuestions())
                questions.append(QuestionUIO(id: "last", question: "추가로 남기고 싶은 이야기나 느낀 점이 있다면 자유롭게 작성해주세요."))
            } catch {
                print(error.localizedDescription)
            }
        }
        .alert("한줄평 작성 완료", isPresented: $showReviewCreatedAlert) {
            Button {
                dismiss()
            } label: {
                Text("확인")
            }
        } message: {
            Text("한줄평이 작성되었습니다.")
        }
        #if os(iOS)
        .sensoryFeedback(.selection, trigger: currentQuestionIndex)
        #endif
    }
}

extension ReviewCreateView {    
    func questionCell(question: QuestionUIO) -> some View {
        VStack(spacing: 16) {
            Text(question.question)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.pink)
            
            if let detail = question.detail {
                Text(detail)
                    .multilineTextAlignment(.center)
            }
            
            switch question.id {
            case "first":
                HStack(spacing: 16) {
                    Button {
                        recommended = true
                        currentQuestionIndex += 1
                    } label: {
                        Text("추천")
                            .font(.title3)
                            .foregroundStyle(Color.white)
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color.pink)
                            )
                    }
                    
                    Text("|")
                        .font(.title3)
                    
                    Button {
                        recommended = false
                        currentQuestionIndex += 1
                    } label: {
                        Text("비추천")
                            .font(.title3)
                            .foregroundStyle(Color.white)
                            .padding(4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundStyle(Color.gray)
                            )
                    }
                }
            case "last":
                VStack {
                    TextField("500자 이내", text: $content)
                        .focused($isFocused)
                        .onAppear(perform: {
                            isFocused = true
                        })
                        .onChange(of: content, { oldValue, newValue in
                            if currentQuestionIndex == questions.count - 1 {
                                if newValue == "" {
                                    buttonDisabled = true
                                } else {
                                    buttonDisabled = false
                                }
                            } else {
                                buttonDisabled = true
                            }
                        })
                    
                    Button {
                        showImagePicker = true
                    } label: {
                        if let selectedUIImage = selectedUIImage {
                            Image(uiImage: selectedUIImage)
                                .resizable()
                                .frame(width: 200, height: 200)
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 200, height: 200)
                                .foregroundStyle(Color.gray)
                                .overlay {
                                    Text("사진 추가하기")
                                        .bold()
                                        .foregroundStyle(Color.white)
                                }
                        }
                    }
                    .withMediaPicker(type: .library, isPresented: $showImagePicker, selectedImageURL: $selectedImageURL)
                    .onChange(of: selectedImageURL) {
                        if let selectedImageURL = selectedImageURL {
                            loadUIImage(from: selectedImageURL)
                        }
                    }
                }
            default:
                HStack(alignment: .top) {
                    VStack {
                        QuestionCircleButton(text: "1", currentQuestionIndex: $currentQuestionIndex) {
                            ratings.updateValue(1, forKey: questions[currentQuestionIndex].id)
                        }
                        
                        Text("아니오")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    QuestionCircleButton(text: "2", currentQuestionIndex: $currentQuestionIndex) {
                        ratings.updateValue(2, forKey: questions[currentQuestionIndex].id)
                    }
                    
                    Spacer()
                    
                    QuestionCircleButton(text: "3", currentQuestionIndex: $currentQuestionIndex) {
                        ratings.updateValue(3, forKey: questions[currentQuestionIndex].id)
                    }
                    
                    Spacer()
                    
                    QuestionCircleButton(text: "4", currentQuestionIndex: $currentQuestionIndex) {
                        ratings.updateValue(4, forKey: questions[currentQuestionIndex].id)
                    }
                    
                    Spacer()
                    
                    VStack {
                        QuestionCircleButton(text: "5", currentQuestionIndex: $currentQuestionIndex) {
                            ratings.updateValue(5, forKey: questions[currentQuestionIndex].id)
                        }
                        
                        Text("네")
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(16)
    }
}

private extension ReviewCreateView {
    func loadUIImage(from url: URL) {
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            self.selectedUIImage = image
        }
    }
}
