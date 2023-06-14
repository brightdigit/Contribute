// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Contribute",
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Contribute",
      targets: ["Contribute"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/jpsim/Yams.git", from: "4.0.4")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(name: "Contribute", dependencies: ["Yams"]),
    .testTarget(
      name: "ContributeTests",
      dependencies: ["Contribute"]
    )
  ]
)
