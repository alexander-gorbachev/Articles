import Foundation

extension DateFormatter {
    static let timeHoursMinutes: DateFormatter = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "HH:mm"
        return dateFormater
    }()
    
    static let yearMonthDay: DateFormatter = {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater
    }()
    
    static let iso8601: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
      formatter.calendar = Calendar(identifier: .iso8601)
      return formatter
    }()
}
