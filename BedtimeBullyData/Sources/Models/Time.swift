//
//  Time.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 12/15/23.
//

import Foundation

public struct Time {

    private let hourComponent: Int
    private let minuteComponent: Int

    public init(hour: Int, minute: Int) throws {
        if hour < 0 || hour >= 24 {
            throw TimeError.invalidHour
        }
        if minute < 0 || minute >= 60 {
            throw TimeError.invalidMinute
        }
        self.hourComponent = hour
        self.minuteComponent = minute
    }

    public init(date: Date) throws {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        guard let hour = components.hour, let minute = components.minute else {
            throw TimeError.invalidDate
        }
        try self.init(hour: hour, minute: minute)
    }

    public func toDate(baseDate: Date) throws -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: baseDate)
        components.hour = hourComponent
        components.minute = minuteComponent

        guard let date = Calendar.current.date(from: components) else {
            throw TimeError.invalidDate
        }

        return date
    }

    public var hour: Int { hourComponent }
    public var minute: Int { minuteComponent }
}

extension Time: Codable {}

public enum TimeError : Error {
  case invalidHour, invalidMinute, invalidDate, invalidComponents
}
