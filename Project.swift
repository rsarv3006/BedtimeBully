import ProjectDescription

struct ProjectTargets {
   static let BedtimeBully = "BedtimeBully"
    static let BedtimeBullyTests = "BedtimeBullyTests"
    static let Notifications = "Notifications"
    static let BedtimeBullyData = "BedtimeBullyData"
    static let BedtimeBullyDataTests = "BedtimeBullyDataTests"
}

let project = Project(
    name: "BedtimeBully",
    settings: Settings.settings(
        base: [
            "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor"
        ],
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
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard"
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
            sources: ["Notifications/Sources/**"]
        ),
        .target(
            name: ProjectTargets.BedtimeBullyData,
            destinations: .iOS,
            product: .framework,
            bundleId: "rjs.app.dev.BedtimeBullyData",
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
            sources: ["BedtimeBullyData/Tests/**"],
            dependencies: [
                .target(name: ProjectTargets.BedtimeBullyData)
            ]
        )
    ]
)
