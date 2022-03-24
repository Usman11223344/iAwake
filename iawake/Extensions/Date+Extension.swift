//
//  Date+Extension.swift
//  Assessment
//
//  Created by Joseph on 11/01/2022.
//

import Foundation

extension Date {
    func setDateFormat(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: date)
        return date
    }
    
    var localDate: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: self)
        }
    }
    
}
