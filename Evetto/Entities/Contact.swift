import Foundation

public struct Contact: Decodable, Identifiable, Equatable, Hashable {
    public init(
        id: UUID,
        type: Contact.Kind,
        value: String,
        displayValue: String? = nil,
        name: String?,
        title: String?,
        link: String = "https://t.me/evettoapp"
    ) {
        self.id = id
        self.type = type
        self.value = value
        self.displayValue = displayValue ?? value
        self.name = name
        self.title = title
        self.link = link
    }

    public enum Kind: String, Codable, Hashable, CaseIterable, Identifiable {
        case phone, whatsapp, telegram, instagram

        public var id: String {
            rawValue
        }

        public var title: String {
            switch self {
            case .phone: return "Телефон"
            case .whatsapp: return "WhatsApp"
            case .telegram: return "Telegram"
            case .instagram: return "Instagram"
            }
        }
    }

    public let id: UUID
    public let type: Kind
    public let value: String
    public let displayValue: String
    public let name: String?
    public let title: String?
    public let link: String

    public private(set) var isPlaceholder: Bool? = false

    public var formattedTitle: String {
        name ?? type.title
    }

    public static var placeholderTelegram: Contact {
        var contact = Contact(id: UUID(), type: .telegram, value: "evetto", name: "Telegram", title: nil)
        contact.isPlaceholder = true
        return contact
    }

    public static var placeholderWhatsapp: Contact {
        var contact = Contact(id: UUID(), type: .whatsapp, value: "+79190000000", name: "WhatsApp", title: nil)
        contact.isPlaceholder = true
        return contact
    }

    public static var placeholderPhone: Contact {
        var contact = Contact(id: UUID(), type: .phone, value: "+79190000000", name: "Телефон", title: nil)
        contact.isPlaceholder = true
        return contact
    }

    public static var placeholderInstagram: Contact {
        var contact = Contact(id: UUID(), type: .instagram, value: "evettoapp", name: "Evetto App", title: nil)
        contact.isPlaceholder = true
        return contact
    }
}

public extension Contact.Kind {
    var imageName: String {
        switch self {
        case .phone: return "phone-circle"
        case .whatsapp: return "whatsapp-circle"
        case .telegram: return "telegram-circle"
        case .instagram: return "instagram-circle"
        }
    }
}
