import Foundation

/// Represent currency in ISO format.
public enum Currency: String, Codable, CaseIterable, Identifiable {
    /// Turkish Lira
    case TRY
    /// Russian ruble
    case RUB
    /// United States Dollar
    case USD
    /// Euro
    case EUR

    public var id: String {
        rawValue
    }

    public var currencySymbol: String {
        switch self {
        case .TRY: return "₺"
        case .RUB: return "₽"
        case .USD: return "$"
        case .EUR: return "€"
        }
    }
}

extension Currency {

    public var formattedTitle: String {
        let title: String
        switch self {
        case .TRY: title = "Турецкая лира"
        case .RUB: title = "Российский рубль"
        case .USD: title = "Доллар США"
        case .EUR: title = "Евро"
        }
        return currencySymbol + " " + title
    }

}

