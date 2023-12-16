//
//  Time.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 12/15/23.
//

import Foundation

struct Time {

    private let hourComponent: Int
    private let minuteComponent: Int

    init(hour: Int, minute: Int) throws {
        if hour < 0 || hour >= 24 {
            throw TimeError.invalidHour
        }
        if minute < 0 || minute >= 60 {
            throw TimeError.invalidMinute
        }
        self.hourComponent = hour
        self.minuteComponent = minute
    }

    init(date: Date) throws {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        guard let hour = components.hour, let minute = components.minute else {
            throw TimeError.invalidDate
        }
        try self.init(hour: hour, minute: minute)
    }

    func toDate(baseDate: Date) throws -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: baseDate)
        components.hour = hourComponent
        components.minute = minuteComponent

        guard let date = Calendar.current.date(from: components) else {
            throw TimeError.invalidDate
        }

        return date
    }

    var hour: Int { hourComponent }
    var minute: Int { minuteComponent }
}

extension Time: Codable {}

enum TimeError : Error {
  case invalidHour, invalidMinute, invalidDate, invalidComponents
}
