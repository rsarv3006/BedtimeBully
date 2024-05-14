import Foundation
import SwiftUI

class BedtimeStore: ObservableObject {
    @Published var bedtime: Date
    
    init(bedtime: Date) {
        self.bedtime = bedtime
    }
    
    init() {
        self.bedtime = .init()
    }
}
