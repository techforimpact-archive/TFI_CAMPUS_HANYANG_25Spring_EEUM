import Foundation

struct QuestionUIO: Identifiable {
    let id: String
    let question: String
    let detail: String?
    
    init(id: String, question: String, detail: String? = nil) {
        self.id = id
        self.question = question
        self.detail = detail
    }
    
    init(questionDTO: QuestionDTO) {
        self.id = questionDTO.id
        self.question = questionDTO.question
        self.detail = questionDTO.detail
    }
}
