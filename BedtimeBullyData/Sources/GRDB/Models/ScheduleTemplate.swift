import Foundation
import GRDB

public struct ScheduleTemplateDayItem: Codable {
    public var time: Time
    public var isEnabled: Bool
}

public struct GRDBScheduleTemplate: Identifiable, Equatable {
    public static func == (lhs: GRDBScheduleTemplate, rhs: GRDBScheduleTemplate) -> Bool {
        lhs.id == rhs.id
    }

    public var id: String
    public let name: String
    public let isActive: Bool
    
    public var monday: ScheduleTemplateDayItem
    public var tuesday: ScheduleTemplateDayItem
    public var wednesday: ScheduleTemplateDayItem
    public var thursday: ScheduleTemplateDayItem
    public var friday: ScheduleTemplateDayItem
    public var saturday: ScheduleTemplateDayItem
    public var sunday: ScheduleTemplateDayItem
    
    public var notificationScheduleId: String
}

extension GRDBScheduleTemplate: TableRecord {
    public static let databaseTableName = TableNames.ScheduleTemplate.rawValue
}

extension GRDBScheduleTemplate {
    static func new(name: String,
                    monday: ScheduleTemplateDayItem,
                    tuesday: ScheduleTemplateDayItem,
                    wednesday: ScheduleTemplateDayItem,
                    thursday: ScheduleTemplateDayItem,
                    friday: ScheduleTemplateDayItem,
                    saturday: ScheduleTemplateDayItem,
                    sunday: ScheduleTemplateDayItem,
                    notificationScheduleId: String
    ) -> GRDBScheduleTemplate {
        GRDBScheduleTemplate(
            id: UUID().uuidString,
            name: name,
            isActive: true,
            monday: monday,
            tuesday: tuesday,
            wednesday: wednesday,
            thursday: thursday,
            friday: friday,
            saturday: saturday,
            sunday: sunday,
            notificationScheduleId: notificationScheduleId)
    }
}

/// See <https://github.com/groue/GRDB.swift/blob/master/README.md#records>
extension GRDBScheduleTemplate: Codable, FetchableRecord, PersistableRecord {
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
        static let isActive = Column(CodingKeys.isActive)
        
        static let monday = Column(CodingKeys.isActive)
        static let tuesday = Column(CodingKeys.isActive)
        static let wednesday = Column(CodingKeys.isActive)
        static let thursday = Column(CodingKeys.isActive)
        static let friday = Column(CodingKeys.isActive)
        static let saturday = Column(CodingKeys.isActive)
        static let sunday = Column(CodingKeys.isActive)
        
        static let notificationScheduleId = Column(CodingKeys.isActive)
        
    }
}

extension DerivableRequest<GRDBScheduleTemplate> {
}
