import Foundation

struct MyReviewListUIO {
    var reviews: [MyReviewUIO]
    let hasNext: Bool
    let nextCursor: String?
    
    init(reviews: [MyReviewDTO], hasNext: Bool, nextCursor: String?) {
        var tmp: [MyReviewUIO] = []
        for review in reviews {
            tmp.append(MyReviewUIO(myReviewDTO: review))
        }
        self.reviews = tmp
        self.hasNext = hasNext
        self.nextCursor = nextCursor
    }
}
