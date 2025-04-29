import Foundation

struct PlaceUIO: Identifiable {
    let id: String
    let name: String
    let longitude: Double
    let latitude: Double
    let province: String
    let city: String
    let district: String
    let categories: [String]
    let temperature: Double
    let status: String
    let verified: Bool
    
    init(id: String, name: String, longitude: Double, latitude: Double, province: String, city: String, district: String, categories: [String], temperature: Double, status: String, verified: Bool) {
        self.id = id
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.province = province
        self.city = city
        self.district = district
        self.categories = categories
        self.temperature = temperature
        self.status = status
        self.verified = verified
    }
    
    init(placeDTO: PlaceDTO) {
        self.id = placeDTO.id
        self.name = placeDTO.name
        self.longitude = placeDTO.longitude
        self.latitude = placeDTO.latitude
        self.province = placeDTO.province
        self.city = placeDTO.city
        self.district = placeDTO.district
        self.categories = placeDTO.categories
        self.temperature = placeDTO.temperature
        self.status = placeDTO.status
        self.verified = placeDTO.verified
    }
}

extension PlaceUIO {
    static let sample0: PlaceUIO = .init(
        id: "6808f62a8b1ef1775814ebd9",
        name: "마음편한 상담센터",
        longitude: 127.0226,
        latitude: 37.4968,
        province: "서울특별시",
        city: "서초구",
        district: "서초동",
        categories: ["COUNSELING"],
        temperature: 4.5,
        status: "ACTIVE",
        verified: false
    )
    
    static let sample1: PlaceUIO = .init(
        id: "6808f62a8b1ef1775814ebda",
        name: "희망 정신건강의학과",
        longitude: 127.0317,
        latitude: 37.5032,
        province: "서울특별시",
        city: "강남구",
        district: "역삼동",
        categories: ["HOSPITAL"],
        temperature: 4.7,
        status: "ACTIVE",
        verified: false
    )
    
    static let sample2: PlaceUIO = .init(
        id: "6808f62a8b1ef1775814ebdb",
        name: "안전한 쉼터",
        longitude: 126.9812,
        latitude: 37.5665,
        province: "서울특별시",
        city: "종로구",
        district: "종로1가",
        categories: ["SHELTER"],
        temperature: 4.6,
        status: "ACTIVE",
        verified: false
    )
    
    static let samples: [PlaceUIO] = [sample0, sample1, sample2]
}
