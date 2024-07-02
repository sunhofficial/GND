//
//  String+.swift
//  GND
//
//  Created by 235 on 6/24/24.
//

import Foundation
extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH-mm-ssXXXXX"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.date(from: self)
    }
}
