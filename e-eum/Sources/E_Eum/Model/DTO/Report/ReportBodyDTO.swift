import Foundation

struct ReportBodyDTO: Encodable {
    let contentType: String
    let reportType: String
}

enum ContentType: String {
    case place = "PLACE"
    case review = "REVIEW"
}

enum ReportType: String {
    case incorrectInfo = "INCORRECT_INFO"
    case commercialAd = "COMMERCIAL_AD"
    case spam = "SPAM"
    case profanity = "PROFANITY"
    case other = "OTHER"
}
