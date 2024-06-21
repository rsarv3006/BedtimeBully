import Combine
import GRDB
import GRDBQuery

/// A player request can be used with the `@Query` property wrapper in order to
/// feed a view with a list of players.
///
/// For example:
///
///     struct MyView: View {
///         @Query(PlayerRequest(ordering: .byName)) private var players: [Player]
///
///         var body: some View {
///             List(players) { player in ... )
///         }
///     }
public struct ConfigRequest: Queryable {
    // MARK: - Queryable Implementation
    
    public init() {}
    
    public static var defaultValue: GRDBConfig? { nil }
    
    public func publisher(in appDatabase: AppDatabase) -> AnyPublisher<GRDBConfig?, Error> {
        // Build the publisher from the general-purpose read-only access
        // granted by `appDatabase.reader`.
        // Some apps will prefer to call a dedicated method of `appDatabase`.
        ValueObservation
            .tracking(fetchValue(_:))
            .publisher(
                in: appDatabase.reader,
                // The `.immediate` scheduling feeds the view right on
                // subscription, and avoids an undesired animation when the
                // application starts.
                scheduling: .immediate)
            .eraseToAnyPublisher()
    }
    
    // This method is not required by Queryable, but it makes it easier
    // to test PlayerRequest.
    func fetchValue(_ db: Database) throws -> GRDBConfig? {
        return try GRDBConfig.all().fetchAll(db).first
    }
}
