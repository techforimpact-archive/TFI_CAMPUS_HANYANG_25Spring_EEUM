import SwiftUI
import SkipKit
import UIKit

struct ReviewCreateView: View {
    @Environment(\.dismiss) private var dismiss
    
    let placeId: String
    
    private let type: MediaPickerType = .library
    
    @State private var placeService = PlaceService()
    @State private var reviewService = ReviewService()
    @State private var questions: [QuestionUIO] = []
    @State private var currentQuestionIndex: Int = 0
    @State private var buttonDisabled: Bool = true
    @State private var content: String = ""
    @State private var ratings: Dictionary<String, Int> = [:]
    @State private var showImagePicker = false
    @State private var selectedImageURL: URL?
    @State private var selectedUIImage: UIImage?
    @State private var showReviewCreatedAlert: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            headerPageArea
            
            Spacer()
            
            if questions.isEmpty {
                ProgressView()
            } else {
                questionCell(question: questions[currentQuestionIndex])
                    .animation(.bouncy(duration: 1), value: currentQuestionIndex)
            }
            
            Spacer()
            
            BasicButton(title: "한줄평 작성하기", disabled: $buttonDisabled) {
                createReview()
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
        }
        .onAppear {
            loadQuestion()
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

private extension ReviewCreateView {
    var headerPageArea: some View {
        HStack(spacing: 40) {
            Button {
                currentQuestionIndex -= 1
            } label: {
                Image(systemName: "arrow.left")
                    .bold()
                    .foregroundStyle(currentQuestionIndex == 0 ? Color.gray : Color.black)
            }
            .disabled(currentQuestionIndex == 0)
            
            Text("\(currentQuestionIndex + 1) / \(questions.count)")
                .animation(.bouncy(duration: 1), value: currentQuestionIndex)
            
            Button {
                currentQuestionIndex += 1
            } label: {
                Image(systemName: "arrow.forward")
                    .bold()
                    .foregroundStyle(currentQuestionIndex == questions.count - 1 ? Color.gray : Color.black)
            }
            .disabled(currentQuestionIndex == questions.count - 1)
        }
    }
    
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
            case "content":
                VStack {
                    TextEditor(text: $content)
                        .multilineTextAlignment(.leading)
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
                            HStack {
                                Image(uiImage: selectedUIImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                VStack {
                                    Text("사진 변경하기")
                                        .bold()
                                        .foregroundStyle(Color.black)
                                    
                                    Text("최대 1장")
                                        .foregroundStyle(Color.black)
                                }
                            }
                        } else {
                            HStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(Color.gray)
                                    .overlay {
                                        Image(systemName: "plus")
                                            .bold()
                                            .foregroundStyle(Color.white)
                                    }
                                
                                VStack {
                                    Text("사진 추가하기")
                                        .bold()
                                        .foregroundStyle(Color.black)
                                    
                                    Text("최대 1장")
                                        .foregroundStyle(Color.black)
                                }
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
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .foregroundStyle(Color.pink)
                }
            default:
                HStack(alignment: .top) {
                    VStack(spacing: 16) {
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
                    
                    VStack(spacing: 16) {
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
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
}

private extension ReviewCreateView {
    func loadQuestion() {
        Task {
            do {
                questions.append(contentsOf: try await reviewService.getQuestions())
                questions.append(QuestionUIO(id: "content", question: "추가로 남기고 싶은 이야기나 느낀 점이 있다면 자유롭게 작성해주세요.", detail: "부적절하거나 다른 사용자에게 불쾌감을 줄 수 있는 컨텐츠를 게시할 경우 제재를 받을 수 있습니다."))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadUIImage(from url: URL) {
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            self.selectedUIImage = image
        }
    }
    
    func createReview() {
        Task {
            do {
                if let selectedUIImage = selectedUIImage {
                    _ = try await placeService.createPlaceReview(placeID: placeId, content: content, ratings: ratings, recommended: true, images: [selectedUIImage])
                } else {
                    _ = try await placeService.createPlaceReview(placeID: placeId, content: content, ratings: ratings, recommended: true, images: [])
                }
                showReviewCreatedAlert = true
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
