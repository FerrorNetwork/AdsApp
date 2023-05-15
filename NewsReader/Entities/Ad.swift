import Foundation
import Fakery

let faker = Faker(locale: "ru")

struct Ad: Decodable {
    struct Rating: Decodable {
        let rate: Double
        let count: Int
        
        static var placeholder: Rating {
            Rating(rate: faker.number.randomDouble(), count: faker.number.randomInt())
        }
    }
    
    let id: Int
    let title: String
    let price: Double
    let description, category: String
    let image: String
    let rating: Rating
    
    static var placeholder: Ad {
        Ad(id: faker.number.randomInt(),
           title: faker.lorem.word(),
           price: faker.number.randomDouble(min: 0.0, max: 10.0),
           description: faker.lorem.words(amount: 6),
           category: faker.lorem.word(),
           image: faker.internet.image(),
           rating: Rating.placeholder)
    }
}
