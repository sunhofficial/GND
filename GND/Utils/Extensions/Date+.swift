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
    func formatToCalendarString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: self)
    }
    func formattedToChart(for range: DropRange) -> String {
        let formatter = DateFormatter()
        switch range {
        case .hour:
            formatter.dateFormat = "HH"
        case .day:
            formatter.dateFormat = "E"
        case .week:
            let weekOfMonth = Calendar.current.component(.weekOfMonth, from: self)
                     let month = Calendar.current.component(.month, from: self)
                     return "\(month)월 \(weekOfMonth)주차"
        case .month:
            formatter.dateFormat = "MM"
        }
        return formatter.string(from: self)
    }
}
