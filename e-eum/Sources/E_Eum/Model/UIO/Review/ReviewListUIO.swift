import Foundation

struct ReviewListUIO {
    var reviews: [ReviewUIO]
    let hasNext: Bool
    let nextCursor: String
    
    init(reviews: [ReviewDTO], hasNext: Bool, nextCursor: String) {
        var tmp: [ReviewUIO] = []
        for review in reviews {
            tmp.append(ReviewUIO(reviewDTO: review))
        }
        self.reviews = tmp
        self.hasNext = hasNext
        self.nextCursor = nextCursor
    }
}
