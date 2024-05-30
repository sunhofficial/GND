//
//  Date+.swift
//  GND
//
//  Created by 235 on 5/30/24.
//

import Foundation
extension Date {
    func formattedDateString() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withTimeZone, .withDashSeparatorInDate, .withColonSeparatorInTime]
        isoFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return isoFormatter.string(from: self)
    }
}
