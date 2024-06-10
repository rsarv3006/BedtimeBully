import Foundation
import SwiftData

public enum BedtimeHistoryStatus: String, Codable {
    case valid
}

extension SchemaV1_0_1 {
    @Model
    public class BedtimeHistory {
        @Attribute(.unique) public let id: UUID
        public let bedtimeTarget: TimeInterval
        public let inBedTime: TimeInterval
        public let status: String

        public init(bedtimeTarget: TimeInterval, inBedTime: TimeInterval, status: BedtimeHistoryStatus) {
            self.id = UUID()
            self.bedtimeTarget = bedtimeTarget
            self.inBedTime = inBedTime
            self.status = BedtimeHistoryStatus.valid.rawValue
        }
    }
}
