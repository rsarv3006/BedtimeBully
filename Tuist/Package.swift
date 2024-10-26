// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [
            "GRDB": .framework,
            "GRDBQuery": .framework,
            "Bedrock": .framework,
        ]
    )
#endif

let package = Package(
    name: "BedtimeBully",
    dependencies: [
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
        .package(url: "https://github.com/groue/GRDB.swift", from: "6.29.3"),
        .package(url: "https://github.com/groue/GRDBQuery", from: "0.8.0"),
        .package(url: "https://github.com/rsarv3006/bedrock", from: "1.0.6"),
    ]
)
