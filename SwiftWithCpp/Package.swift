// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SwiftWithCpp",
    products: [
        .library(
            name: "SwiftWithCpp",
            targets: ["SwiftTarget"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftTarget",
            dependencies: ["ObjcTarget"]
        ),
        .target(
            name: "ObjcTarget",
            dependencies: ["CppTarget"]
        ),
        .target(
            name: "CppTarget",
            exclude: ["include"]
        ),
        .testTarget(
            name: "SwiftWithCppTests",
            dependencies: ["SwiftTarget"]
        ),
    ],
    cxxLanguageStandard: .cxx17
)
