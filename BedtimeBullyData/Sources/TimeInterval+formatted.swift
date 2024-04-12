//
//  TimeInterval+formatted.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/27/23.
//

import Foundation

public extension TimeInterval {
    func formatted() -> String {
        let seconds = Int(self)

        let minutes = seconds / 60
        if minutes == 1 {
            return "1 minute"
        } else if minutes > 0 {
            return "\(minutes) minutes"
        }

        let hours = minutes / 60
        if hours == 1 {
            return "1 hour"
        } else if hours > 0 {
            return "\(hours) hours"
        }

        if seconds == 1 {
            return "1 second"
        } else {
            return "\(seconds) seconds"
        }
    }
}
