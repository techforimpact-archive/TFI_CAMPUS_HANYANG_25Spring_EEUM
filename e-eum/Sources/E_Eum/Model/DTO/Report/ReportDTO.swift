import Foundation

struct ReportDTO: Decodable {
    let reportId: String
    let contentId: String
    let reportType: String
    let reporterId: String
    let createdAt: String
}
