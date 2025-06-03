import Foundation

struct PlaceDetailUIO: Identifiable {
    let id: String
    let name: String
    let longitude: Double
    let latitude: Double
    let province: String
    let city: String
    let district: String
    let fullAddress: String
    let categories: [String]
    let imageUrls: [String]
    let description: String
    let phone: String
    let email: String
    let website: String
    let temperature: Double
    let reviewCount: Int
    let status: String
    let verified: Bool
    let favorite: Bool
    
    init(id: String, name: String, longitude: Double, latitude: Double, province: String, city: String, district: String, fullAddress: String, categories: [String], imageUrls: [String], description: String, phone: String, email: String, website: String, temperature: Double, reviewCount: Int, status: String, verified: Bool, favorite: Bool) {
        self.id = id
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.province = province
        self.city = city
        self.district = district
        self.fullAddress = fullAddress
        self.categories = categories
        self.imageUrls = imageUrls
        self.description = description
        self.phone = phone
        self.email = email
        self.website = website
        self.temperature = temperature
        self.reviewCount = reviewCount
        self.status = status
        self.verified = verified
        self.favorite = favorite
    }
    
    init(placeDetailDTO: PlaceDetailDTO) {
        self.id = placeDetailDTO.id
        self.name = placeDetailDTO.name
        self.longitude = placeDetailDTO.longitude
        self.latitude = placeDetailDTO.latitude
        self.province = placeDetailDTO.province
        self.city = placeDetailDTO.city
        self.district = placeDetailDTO.district
        self.fullAddress = placeDetailDTO.fullAddress
        self.categories = placeDetailDTO.categories
        self.imageUrls = placeDetailDTO.imageUrls
        self.description = placeDetailDTO.description
        self.phone = placeDetailDTO.phone
        self.email = placeDetailDTO.email
        self.website = placeDetailDTO.website
        self.temperature = placeDetailDTO.temperature
        self.reviewCount = placeDetailDTO.reviewCount
        self.status = placeDetailDTO.status
        self.verified = placeDetailDTO.verified
        self.favorite = placeDetailDTO.favorite
    }
}

extension PlaceDetailUIO {
    static let sample: PlaceDetailUIO = .init(
        id: "6808f62a8b1ef1775814ebdb",
        name: "안전한 쉼터",
        longitude: 126.9812,
        latitude: 37.5665,
        province: "서울특별시",
        city: "종로구",
        district: "종로1가",
        fullAddress: "서울특별시 종로구 종로1가",
        categories: ["SHELTER", "COUNSELING"],
        imageUrls: [],
        description: "위기 상황에 처한 여성과 아동을 위한 안전한 쉼터입니다. 심리 상담과 함께 법률 지원 서비스도 제공합니다.",
        phone: "02-345-6789",
        email: "help@shelter.example.com",
        website: "https://shelter.example.com",
        temperature: 4.6,
        reviewCount: 32,
        status: "ACTIVE",
        verified: false,
        favorite: true
    )
}
