import Combine
import GRDB
import GRDBQuery

public struct BedtimeRequest: Queryable {
    public init() {}

    public static var defaultValue: [GRDBBedtime] { [] }

    public func publisher(in appDatabase: AppDatabase) -> AnyPublisher<[GRDBBedtime], Error> {
        ValueObservation
            .tracking(fetchValue(_:))
            .publisher(in: appDatabase.reader, scheduling: .immediate)
            .eraseToAnyPublisher()
    }

    func fetchValue(_ db: Database) throws -> [GRDBBedtime] {
        return try GRDBBedtime.all().fetchAll(db)
    }
}
