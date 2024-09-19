import Foundation
import Bedrock

public typealias NetworkConfigService = ConfigService

public struct Config: GenericConfig {
    public let minAppVersion: String?
    public let isStreakViewEnabled: Bool?

    public init(
        apiUrl: String,
        anonToken: String,
        minAppVersion: String?,
        isStreakViewEnabled: Bool?
    ) {
        self.minAppVersion = minAppVersion
        self.isStreakViewEnabled = isStreakViewEnabled
    }
}

public extension ConfigService where T == Config {
    convenience init() {
        self.init(
            remoteLoader: RemoteConfigLoader(),
            localLoader: LocalConfigLoader(),
            cacheStrategy: TimeBasedCacheStrategy()
        )
    }
    
    static let shared = ConfigService.init()
}

public class RemoteConfigLoader: ConfigLoader {
    public init() {}

    public func loadConfig() async -> Config? {
        let configApiUrl = PlistHelpers.getKeyValueFromPlist(plistFileName: "Config", key: "ConfigApiUrl")
        let configApiToken = PlistHelpers.getKeyValueFromPlist(plistFileName: "Config", key: "ConfigApiToken")
        guard let configApiUrl,
              let configApiToken,
              let url = URL(string: "\(configApiUrl)/api/v1/config/bedtimebully")
        else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(configApiToken)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                let configReturn = try JsonHelpers.decoder.decode(ConfigReturnDto<Config>.self, from: data)
                let config = configReturn.data.config
                return config

            } else {
                let serverError = try JsonHelpers.decoder.decode(ServerErrorMessage.self, from: data)
                throw ServiceErrors.custom(message: serverError.error)
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

public class LocalConfigLoader: ConfigLoader {
    public init() {}

    public func loadConfig() async -> Config? {
        return JsonHelpers.loadJSON(filename: "DefaultConfig")
    }
}

