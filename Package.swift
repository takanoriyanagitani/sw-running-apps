// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "RunningAppInfo",
  platforms: [
    .macOS(.v11)
  ],
  dependencies: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.58.2")
  ],
  targets: [
    .executableTarget(
      name: "RunningAppInfo",
      swiftSettings: [
        .unsafeFlags(
          ["-cross-module-optimization"],
          .when(configuration: .release)
        )
      ]
    )
  ]
)
