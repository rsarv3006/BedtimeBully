//
//  Date+.swift
//  BedtimeBullyData
//
//  Created by Robert J. Sarvis Jr on 11/28/23.
//

import Foundation

public extension Date {
    func getTime() throws -> Time {
        return try Time(hour: hour, minute: minute)
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    var dayOfWeek: DayOfTheWeek {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: self)
        return Date.DayOfTheWeek.allCases[dayOfWeek - 1]
    }
    
    enum DayOfTheWeek: String, Codable, CaseIterable {
        case Sunday
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
    }
    
    var isInPast: Bool {
        return timeIntervalSinceNow < 0
    }
    
    static var tomorrow: Date {
        return Date().addingTimeInterval(86400)
    }
}
