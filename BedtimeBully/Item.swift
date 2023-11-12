//
//  Item.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 11/12/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
