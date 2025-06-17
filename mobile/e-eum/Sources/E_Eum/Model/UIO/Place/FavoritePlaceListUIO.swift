import Foundation

struct FavoritePlaceListUIO {
    var places: [FavoritePlaceUIO]
    let hasNext: Bool
    let nextCursor: String?
    
    init(places: [FavoritePlaceDTO], hasNext: Bool, nextCursor: String?) {
        var tmp: [FavoritePlaceUIO] = []
        for place in places {
            tmp.append(FavoritePlaceUIO(favoritePlaceDTO: place))
        }
        self.places = tmp
        self.hasNext = hasNext
        self.nextCursor = nextCursor
    }
}
