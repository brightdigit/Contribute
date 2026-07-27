// swift-tools-version: 6.4
// swiftlint:disable explicit_acl explicit_top_level_acl

import PackageDescription

let package = Package(
  name: "Contribute",
  // All Apple platforms supported. Minimums satisfy the only platform-constrained
  // dependency, SwiftSoup (.macOS(.v10_15)/.iOS(.v13)/.tvOS(.v13)/.watchOS(.v6));
  // Yams and swift-markdown declare none.
  platforms: [
    .macOS(.v12),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6)
  ],
  products: [
    .library(
      name: "Contribute",
      targets: ["Contribute"]
    )
  ],
  dependencies: [
    .package(
      url: "https://github.com/jpsim/Yams.git",
      from: "6.0.0"
    ),
    // Back on upstream scinfu/SwiftSoup as of 2.13.7. This previously used a brightdigit
    // fork carrying one patch — dropping `@inline(__always)` from
    // `StringUtil.appendNormalisedWhitespaceBytes`, whose forced inlining into
    // `Element.appendNormalisedText` crashed the Swift 6.4 optimizer under
    // `swift build -c release` (CI run 27729200662). 2.13.7 still declares that
    // attribute, but the surrounding code was rewritten upstream and the crash no longer
    // reproduces: `swift build -c release` + `swift test -c release` both pass. A version
    // pin is required regardless — SwiftPM only lets a version-resolved package depend on
    // other version-resolved packages, so a `branch:` pin here would make Contribute
    // unconsumable via `from:` by the Contribute* packages and the root.
    .package(
      url: "https://github.com/scinfu/SwiftSoup.git",
      from: "2.13.7"
    ),
    // Version-pinned for the same reason as SwiftSoup above. 0.8.0 is the newest
    // semver release and pulls swift-cmark 0.8.0 transitively. URL standardised on
    // `swiftlang` (matches the root package) so SPM resolves a single
    // `swift-markdown` identity.
    .package(
      url: "https://github.com/swiftlang/swift-markdown.git",
      from: "0.8.0"
    ),
  ],
  targets: [
    .target(
      name: "Contribute",
      dependencies: [
        "Yams",
        "SwiftSoup",
        .product(name: "Markdown", package: "swift-markdown"),
      ]
    ),
    .testTarget(
      name: "ContributeTests",
      dependencies: ["Contribute"]
    )
  ]
)
