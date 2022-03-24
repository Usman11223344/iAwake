//
//  String+extension.swift
//  Assessment
//
//  Created by Joseph on 11/01/2022.
//

import Foundation
extension String {
    func convertToLocalDateFromUTCDate(dateStr : Date) -> String {
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "MM/dd/yy hh:mm:ss a"
        let localTime = formatter2.string(from: dateStr)
        return localTime
    }
    
    var getGMTDate: Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from: self)
            return date
        }
    }
    
}
