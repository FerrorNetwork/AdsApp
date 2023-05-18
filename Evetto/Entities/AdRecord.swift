import Foundation

public struct AdResponse: Decodable, Identifiable, Hashable {
    
    private(set) var isPlaceholder: Bool? = false

    public struct User: Decodable, Hashable {
        public let id: UUID
        public let username: String
        public let name: String?
    }

    public struct Category: Decodable, Hashable {
        public let id: UUID
        public let title: String
        public let parentTitle: String?

        public var displayTitle: String {
            if let parentTitle = parentTitle {
                return "\(parentTitle) / \(self.title)"
            } else {
                return title
            }
        }
    }

    public struct AdPrice: Decodable, Hashable {
        public enum PaymentInterval: String, Codable {
            case oneTime, daily, weekly, monthly, yearly
        }

        public let amount: Double
        public let currency: Currency
        public let isNegotable: Bool?
        public let paymentInterval: PaymentInterval
    }

    public struct LocationInfo: Decodable, Hashable {
        public let id: UUID
        public let area: String
        public let district: String?

        public var displayTitle: String {
            if let district = district {
                return "\(self.area), \(district)"
            } else {
                return area
            }
        }
    }

    public struct FileInfo: Decodable, Hashable {
        public let id: UUID
        public let link: URL
        public let size: Int64
        public let `extension`: String
        public let type: String
    }

    public let id: UUID

    // Could be null if user is "onboarding user".
    public let user: User?

    public let title: String
    public let description: String?
    public let category: Category?
    public let createdAt: Date
    public let updatedAt: Date
    public let price: AdPrice?
    public let location: LocationInfo?
    public var previewImageURL: URL?
    public var isFavorite: Bool?

    // Onboarding sign-up link.
    public var onboardingLink: String?
    
    public private(set) var isOnboarding: Bool?

    public private(set) var contacts: [Contact]?
    public private(set) var attachments: [FileInfo]?

    public let isExpired: Bool?
    public let isPublished: Bool?

    public static func placeholder(
        currency: Currency,
        imageURL: URL? = nil
    ) -> AdResponse {
        var ad = AdResponse(
            id: UUID(),
            user: nil,
            title: "Вилла в Текирдаге",
            description: """
            Вилла в самом сердце Стамбула. 250 комнат, 30 ванн, аквадискотека и всё такое прилагается. Продаю из-за шумных соседей, хочу переехать поближе к морю. Документы все в порядке, коммуналки оплачены, не отказная.
            """,
            category: Category(id: UUID(), title: "Квартиры", parentTitle: "Недвижимость"),
            createdAt: Date(timeIntervalSinceNow: -Double.random(in: 100...1_000)),
            updatedAt: Date(),
            price: AdPrice(
                amount: 1000,
                currency: currency,
                isNegotable: true,
                paymentInterval: .oneTime
            ),
            location: LocationInfo(
                id: UUID(),
                area: "Стамбул",
                district: "Фатих"
            ),
            previewImageURL: imageURL,
            onboardingLink: nil,
            isOnboarding: Bool.random(),
            contacts: [
                .placeholderPhone,
                .placeholderTelegram,
                .placeholderWhatsapp
            ],
            attachments: [
                .init(
                    id: UUID(),
                    link: URL(string: "https://images.unsplash.com/photo-1661169693525-69a05e0e0843?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDJ8Ym84alFLVGFFMFl8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60")!,
                    size: 1024,
                    extension: "jpeg",
                    type: "jpg"
                ),
                .init(
                    id: UUID(),
                    link: URL(string: "https://images.unsplash.com/photo-1661094438697-6095d87acce6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHx0b3BpYy1mZWVkfDR8Ym84alFLVGFFMFl8fGVufDB8fHx8&auto=format&fit=crop&w=800&q=60")!,
                    size: 1024,
                    extension: "jpeg",
                    type: "jpg"
                )
            ],
            isExpired: false,
            isPublished: true
        )
        ad.isPlaceholder = true
        return ad
    }

}
