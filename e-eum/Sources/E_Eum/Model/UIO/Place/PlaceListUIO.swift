import Foundation

struct PlaceListUIO {
    var places: [PlaceUIO]
    let hasNext: Bool
    let nextCursor: String?
    
    init(places: [PlaceDTO], hasNext: Bool, nextCursor: String?) {
        var tmp: [PlaceUIO] = []
        for place in places {
            tmp.append(PlaceUIO(placeDTO: place))
        }
        self.places = tmp
        self.hasNext = hasNext
        self.nextCursor = nextCursor
    }
}
