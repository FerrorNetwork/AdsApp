
import Foundation

extension DateFormatter {
    static var dateFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd MMMM y, HH:mm")
        return dateFormatter
    }
}
