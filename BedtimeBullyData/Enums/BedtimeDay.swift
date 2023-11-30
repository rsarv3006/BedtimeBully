//
//  BedtimeDay.swift
//  BedtimeBullyData
//
//  Created by Robert J. Sarvis Jr on 11/28/23.
//

import Foundation

enum BedtimeDay: String, Codable {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    static let allCases: [BedtimeDay] = [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
}
