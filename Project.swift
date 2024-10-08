import ProjectDescription

let markettingVersion = "1.2.0"

extension SettingsDictionary {
    func setProjectVersions() -> SettingsDictionary {
        return appleGenericVersioningSystem().merging([
            "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
        ])
    }
}

enum ProjectTargets {
    static let BedtimeBully = "BedtimeBully"
    static let BedtimeBullyTests = "BedtimeBullyTests"
    static let Notifications = "Notifications"
    static let BedtimeBullyData = "BedtimeBullyData"
    static let BedtimeBullyDataTests = "BedtimeBullyDataTests"
    static let NotificationsTests = "NotificationsTests"
    static let NetworkConfig = "NetworkConfig"
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
            ),
        ], defaultSettings: .recommended()
    ),
    targets: [
        .target(
            name: ProjectTargets.BedtimeBully,
            destinations: .iOS,
            product: .app,
            bundleId: "rjs.app.dev.BedtimeBully",
            deploymentTargets: DeploymentTargets.iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait",
                    ],
                    "CFBundleShortVersionString": "\(markettingVersion)",
                    "UIBackgroundModes": ["fetch", "processing"],
                    "BGTaskSchedulerPermittedIdentifiers": ["rjs.app.dev.BedtimeBully.refreshBedtimeNotifications"],
                ]
            ),
            sources: ["BedtimeBully/Sources/**"],
            resources: ["BedtimeBully/Resources/**"],
            dependencies: [
                .target(name: ProjectTargets.Notifications),
                .target(name: ProjectTargets.BedtimeBullyData),
                .target(name: ProjectTargets.NetworkConfig),
                .external(name: "GRDBQuery"),
                .external(name: "Bedrock"),
            ]
        ),
        .target(
            name: ProjectTargets.BedtimeBullyTests,
            destinations: .iOS,
            product: .unitTests,
            bundleId: "rjs.app.dev.BedtimeBullyTests",
            deploymentTargets: DeploymentTargets.iOS("16.0"),
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
            deploymentTargets: DeploymentTargets.iOS("16.0"),
            sources: ["Notifications/Sources/**"]
        ),
        .target(
            name: ProjectTargets.NotificationsTests,
            destinations: .iOS,
            product: .unitTests,
            bundleId: "rjs.app.dev.NotificationsTests",
            deploymentTargets: DeploymentTargets.iOS("16.0"),
            sources: ["Notifications/Tests/**"]
        ),
        .target(
            name: ProjectTargets.BedtimeBullyData,
            destinations: .iOS,
            product: .framework,
            bundleId: "rjs.app.dev.BedtimeBullyData",
            deploymentTargets: DeploymentTargets.iOS("16.0"),
            sources: ["BedtimeBullyData/Sources/**"],
            dependencies: [
                .target(name: ProjectTargets.Notifications),
                .external(name: "GRDB"),
            ]
        ),
        .target(
            name: ProjectTargets.BedtimeBullyDataTests,
            destinations: .iOS,
            product: .unitTests,
            bundleId: "rjs.app.dev.BedtimeBullyDataTests",
            deploymentTargets: DeploymentTargets.iOS("16.0"),
            sources: ["BedtimeBullyData/Tests/**"],
            dependencies: [
                .target(name: ProjectTargets.BedtimeBullyData),
            ]
        ),
        .target(
            name: ProjectTargets.NetworkConfig,
            destinations: .iOS,
            product: .framework,
            bundleId: "rjs.app.dev.NetworkConfig",
            deploymentTargets: DeploymentTargets.iOS("16.0"),
            sources: ["NetworkConfig/Sources/**"],
            dependencies: [
                .external(name: "Bedrock"),
            ]
        ),
    ]
)
