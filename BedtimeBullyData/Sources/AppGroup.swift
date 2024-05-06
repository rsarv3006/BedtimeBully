import Foundation

public enum AppGroup: String {
    case bedtimeBully = "group.rjs.app.dev.bedtimebully"

    public var containerURL: URL {
        switch self {
        case .bedtimeBully:
            return FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: self.rawValue)!
        }
    }

    public var defaults: UserDefaults {
        switch self {
        case .bedtimeBully:
            return UserDefaults(suiteName: self.rawValue)!
        }
    }
}
