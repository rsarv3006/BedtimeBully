import Foundation
import SwiftUI
import BedtimeBullyData

class BedtimeStore: ObservableObject {
    @Published var bedtime: Date
    @Published var bedtimeModel: GRDBBedtime?
    @Published var hasBedtime = false
    
    init(bedtime: Date) {
        self.bedtime = bedtime
    }
    
    init() {
        self.bedtime = .init()
    }
}
