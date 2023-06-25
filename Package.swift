// swift-tools-version: 5.8
// swiftlint:disable explicit_acl explicit_top_level_acl

import PackageDescription

let package = Package(
  name: "Contribute",
  platforms: [.macOS(.v12)],
  products: [
    .library(
      name: "Contribute",
      targets: ["Contribute"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/jpsim/Yams.git",
      from: "4.0.4"
    ),
    .package(
      url: "https://github.com/BrightDigit/Prch.git",
      from: "0.2.1"
    )
  ],
  targets: [
    .target(
      name: "Contribute",
      dependencies: ["Yams", "Prch"]
    ),
    .testTarget(
      name: "ContributeTests",
      dependencies: ["Contribute"]
    )
  ]
)
