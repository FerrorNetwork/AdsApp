
import Foundation

extension NumberFormatter {
    
    static var priceNumberForrmatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.formattingContext = .standalone
        numberFormatter.numberStyle = .currency
        return numberFormatter
    }
    
}
