// swift-tools-version:5.8

import PackageDescription
import Foundation

// MARK: - Dependencies

func hasFile(_ path: String) -> Bool {
    FileManager.default.fileExists(
        atPath: URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .appendingPathComponent(path)
            .path
    )
}

// DO NOT CHANGE DEFAULT VALUES IN TRUNK
let useRegistry = hasFile(".spm-use-registry") || false
let useVarioqubLocal = hasFile(".spm-use-varioqub-local") || false

let varioqubCurrentVersion: Version = "1.3.0"

struct ExternalDependency {
    let package: String
    let dependency: Package.Dependency

    init(url: String, registryId: String, version: VersionSpec, localPath: String? = nil) {
        if localPath != nil {
            self.package = registryId
            self.dependency = .package(name: self.package, path: localPath!)
        } else if useRegistry {
            self.package = registryId
            self.dependency = switch version {
            case .upToNextMajor(from: let from): .package(id: self.package, .upToNextMajor(from: from))
            case .exact(let v): .package(id: self.package, exact: v)
            }
        } else {
            self.package = URL(string: url)!.lastPathComponent
            self.dependency = switch version {
            case .upToNextMajor(from: let from): .package(url: url, .upToNextMajor(from: from))
            case .exact(let v): .package(url: url, exact: v)
            }
        }
    }

    enum VersionSpec {
        case upToNextMajor(from: Version)
        case exact(Version)
    }
}

enum SwiftLog {
    private static let dep = ExternalDependency(
        url: "https://github.com/apple/swift-log",
        registryId: "spm-external.swift-log",
        version: .upToNextMajor(from: "1.5.2"),
    )

    static let dependency: Package.Dependency = dep.dependency
    static let logging: Target.Dependency = .product(name: "Logging", package: dep.package)
}

enum Varioqub {
    private static let dep = ExternalDependency(
        url: "https://github.com/appmetrica/varioqub-sdk-ios",
        registryId: "spm-external.Varioqub",
        version: .exact(varioqubCurrentVersion),
        localPath: useVarioqubLocal ? "../varioqub" : nil,
    )

    static let dependency: Package.Dependency = dep.dependency
    static let varioqub: Target.Dependency = .product(name: "Varioqub", package: dep.package)
}

enum DivKit {
    private static let dep = ExternalDependency(
        url: "https://github.com/divkit/divkit-ios",
        registryId: "yandexsuperapp.DivKit",
        version: .upToNextMajor(from: "32.0.0"),
    )

    static let dependency: Package.Dependency = dep.dependency
    static let divkit: Target.Dependency = .product(name: "DivKit", package: dep.package)
}

// MARK: - Module

protocol ModuleDependency {
    var asTargetDependency: Target.Dependency { get }
}

extension String : ModuleDependency {
    var asTargetDependency: Target.Dependency { .target(name: self) }
}

extension Target.Dependency : ModuleDependency {
    var asTargetDependency: Target.Dependency { self }
}

struct Module {
    let name: String
    let dependencies: [Target.Dependency]
    let hasTests: Bool
    let testDependencies: [Target.Dependency]

    init(name: String, dependencies: [ModuleDependency], hasTests: Bool = true, testDependencies: [ModuleDependency] = []) {
        self.name = name
        self.dependencies = dependencies.map(\.asTargetDependency)
        self.hasTests = hasTests
        self.testDependencies = testDependencies.map(\.asTargetDependency)
    }

    func toTargets() -> [Target] {
        var targets: [Target] = [
            .target(
                name: name,
                dependencies: dependencies,
                resources: [.copy("Resources/PrivacyInfo.xcprivacy")],
                swiftSettings: [.define("VQ_MODULES")],
            )
        ]
        if hasTests {
            targets.append(
                .testTarget(
                    name: "\(name)Tests",
                    dependencies: [.target(name: name)] + dependencies + testDependencies,
                    swiftSettings: [.define("VQ_MODULES")],
                )
            )
        }
        return targets
    }
}

extension Module {
    static let ui = "VarioqubUI"
}

// MARK: - UI Module

let ui = Module(
    name: Module.ui,
    dependencies: [
        SwiftLog.logging,
        Varioqub.varioqub,
        DivKit.divkit,
    ],
)

// MARK: - Package definition

let package = Package(
    name: "VarioqubUI",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
    ],
    products: [
        .library(name: "VarioqubUI", targets: [Module.ui]),
    ],
    dependencies: [
        SwiftLog.dependency,
        Varioqub.dependency,
        DivKit.dependency,
    ],
    targets: [
        ui,
    ].flatMap { $0.toTargets() },
)
