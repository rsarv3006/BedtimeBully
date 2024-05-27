import ProjectDescription

extension SettingsDictionary {
    func setProjectVersions() -> SettingsDictionary {
        let currentProjectversion = "1.0.2"
        let markettingVersion = "1"
        return appleGenericVersioningSystem().merging([
            "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
            "CURRENT_PROJECT_VERSION": SettingValue(stringLiteral: currentProjectversion),
            "MARKETING_VERSION": SettingValue(stringLiteral: markettingVersion)
            
        ])
    }
}

struct ProjectTargets {
   static let BedtimeBully = "BedtimeBully"
    static let BedtimeBullyTests = "BedtimeBullyTests"
    static let Notifications = "Notifications"
    static let BedtimeBullyData = "BedtimeBullyData"
    static let BedtimeBullyDataTests = "BedtimeBullyDataTests"
    static let NotificationsTests = "NotificationsTests"
}

let project = Project(
    name: "BedtimeBully",
    settings: Settings.settings(
        base: SettingsDictionary().setProjectVersions(),
        configurations: [
            Configuration.debug(
                name: "Debug",
                settings: SettingsDictionary().automaticCodeSigning(devTeam: "4QGR522B9M")
            ),
            Configuration.release(
                name: "Release",
                settings: SettingsDictionary().automaticCodeSigning(devTeam: "4QGR522B9M")
            )
        ], defaultSettings: .recommended()
    ),
    targets: [
        .target(
            name: ProjectTargets.BedtimeBully,
            destinations: .iOS,
            product: .app,
            bundleId: "rjs.app.dev.BedtimeBully",
            deploymentTargets: DeploymentTargets.iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen"
                ]
            ),
            sources: ["BedtimeBully/Sources/**"],
            resources: ["BedtimeBully/Resources/**"],
            dependencies: [.target(name: ProjectTargets.Notifications), .target(name: ProjectTargets.BedtimeBullyData)]
        ),
        .target(
            name: ProjectTargets.BedtimeBullyTests,
            destinations: .iOS,
            product: .unitTests,
            bundleId: "rjs.app.dev.BedtimeBullyTests",
            deploymentTargets: DeploymentTargets.iOS("17.0"),
            infoPlist: .default,
            sources: ["BedtimeBully/Tests/**"],
            resources: [],
            dependencies: [.target(name: ProjectTargets.BedtimeBully)]
        ),
        .target(
            name: ProjectTargets.Notifications,
            destinations: .iOS,
            product: .framework,
            bundleId: "rjs.app.dev.Notifications",
            deploymentTargets: DeploymentTargets.iOS("17.0"),
            sources: ["Notifications/Sources/**"]
        ),
        .target(
            name: ProjectTargets.NotificationsTests,
            destinations: .iOS,
            product: .unitTests,
            bundleId: "rjs.app.dev.NotificationsTests",
            deploymentTargets: DeploymentTargets.iOS("17.0"),
            sources: ["Notifications/Tests/**"]
        ),
        .target(
            name: ProjectTargets.BedtimeBullyData,
            destinations: .iOS,
            product: .framework,
            bundleId: "rjs.app.dev.BedtimeBullyData",
            deploymentTargets: DeploymentTargets.iOS("17.0"),
            sources: ["BedtimeBullyData/Sources/**"],
            dependencies: [
                .target(name: ProjectTargets.Notifications)
            ]
        ),
        .target(
            name: ProjectTargets.BedtimeBullyDataTests,
            destinations: .iOS,
            product: .unitTests,
            bundleId: "rjs.app.dev.BedtimeBullyDataTests",
            deploymentTargets: DeploymentTargets.iOS("17.0"),
            sources: ["BedtimeBullyData/Tests/**"],
            dependencies: [
                .target(name: ProjectTargets.BedtimeBullyData)
            ]
        )
    ]
)
