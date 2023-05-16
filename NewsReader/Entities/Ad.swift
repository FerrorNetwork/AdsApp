import Foundation
import Fakery
import RxDataSources

let faker = Faker(locale: "ru")

struct Ad: Decodable {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let category: Category
    let images: [String]
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
    let image: String
}



extension Ad: IdentifiableType, Equatable {
    static func == (lhs: Ad, rhs: Ad) -> Bool {
        lhs.id == rhs.id
    }
    
    var identity: String {
        "\(id)"
    }
}
