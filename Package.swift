// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let usedSource: DependencySource = .regular
let varioqubCurrentVersion = "1.2.0"
let spmExternalScope = "spm-external"
let divkitScope = "yandexsuperapp"

let swiftCompilerSettings: [SwiftSetting] = [
    .define("VQ_MODULES"),
]

enum VarioqubTarget: String, CaseIterable {
    case ui = "VarioqubUI"
}

enum VarioqubProduct: String, CaseIterable {
    case ui = "VarioqubUI"
    
    var targets: [VarioqubTarget] {
        switch self {
        case .ui: return [.ui]
        }
    }
}

enum ExternalDependency: CaseIterable {
    case swiftLog
    case varioqub
    case divkit
    
    var version: DependencyVersion {
        switch self {
        case .swiftLog: return .range("1.5.2"..<"2.0.0")
        case .varioqub: return .exact(Version(varioqubCurrentVersion)!)
        case .divkit: return .from("32.0.0")
        }
    }
    
    var regularPackageName: String {
        switch self {
        case .swiftLog: return "swift-log"
        case .varioqub: return "varioqub-sdk-ios"
        case .divkit: return "divkit-ios"
        }
    }
    
    var localPackageName: String {
        switch self {
        case .swiftLog: return "\(spmExternalScope).swift-log"
        case .varioqub: return "varioqub"
        case .divkit: return "\(divkitScope).DivKit"
        }
    }
    
    var spmExternalPackageName: String {
        switch self {
        case .swiftLog: return "\(spmExternalScope).swift-log"
        case .varioqub: return "\(spmExternalScope).varioqub"
        case .divkit: return "\(divkitScope).DivKit"
        }
    }
    
    var regularPackageDependency: Package.Dependency {
        switch self {
        case .swiftLog: return .package(url: "https://github.com/apple/swift-log", version: version)
        case .varioqub: return .package(url: "https://github.com/appmetrica/varioqub-sdk-ios", version: version)
        case .divkit: return .package(url: "https://github.com/divkit/divkit-ios", version: version)
        }
    }
    
    var spmExternalPackageDependency: Package.Dependency {
        switch self {
        case .swiftLog: return .package(id: "\(spmExternalScope).swift-log", version: version)
        case .varioqub: return .package(id: "\(spmExternalScope).Varioqub", version: version)
        case .divkit: return .package(id: "\(divkitScope).DivKit", version: version)
        }
    }
    
    var localPackageDependency: Package.Dependency {
        switch self {
        case .swiftLog: return .package(id: "\(spmExternalScope).swift-log", version: version)
        case .varioqub: return .package(name: "varioqub", path: "../varioqub")
        case .divkit: return .package(id: "\(divkitScope).DivKit", version: version)
        }
    }
}

enum ExternalTargetDependency: String, CaseIterable {
    case swiftLog = "Logging"
    case varioqub = "Varioqub"
    case divkit = "DivKit"
    
    var package: ExternalDependency {
        switch self {
        case .swiftLog: return .swiftLog
        case .varioqub: return .varioqub
        case .divkit: return .divkit
        }
    }
    
    var targetDependency: Target.Dependency {
        .product(name: rawValue, package: package.packageName)
    }
}

let targets: [Target] = [
    .target(varioqubTarget: .ui, externalDependencies: [.swiftLog, .varioqub, .divkit]),
    .testTarget(varioqubTarget: .ui),
]

let package = Package(
        name: "VarioqubUI",
        platforms: [
            .iOS(.v13),
            .tvOS(.v13),
        ],
        products: VarioqubProduct.allCases.map(\.product),
        dependencies: ExternalDependency.allCases.map(\.packageDependency),
        targets: targets
)

extension VarioqubTarget {
    var name: String { rawValue }
    var testsName: String { rawValue + "Tests" }
    var path: String { "Sources/\(rawValue)" }
    var testsPath: String { "Tests/\(rawValue)Tests" }
    var dependency: Target.Dependency { .target(name: rawValue) }
}

extension VarioqubProduct {
    var product: Product {
        .library(
            name: rawValue,
            targets: targets.map(\.name)
        )
    }
}

extension ExternalDependency {

    var packageName: String {
        switch usedSource {
        case .local:
            return localPackageName
        case .regular:
            return regularPackageName
        case .spmExternal:
            return spmExternalPackageName
        }
    }

    var packageDependency: Package.Dependency {
        switch usedSource {
        case .local:
            return localPackageDependency
        case .regular:
            return regularPackageDependency
        case .spmExternal:
            return spmExternalPackageDependency
        }
    }
}

extension Target {
    
    static func target(
        varioqubTarget: VarioqubTarget,
        resources: [Resource]? = nil,
        dependencies: [VarioqubTarget] = [],
        externalDependencies: [ExternalTargetDependency] = [],
        includePrivacyManifest: Bool = true
    ) -> Target {
        var res: [Resource] = resources ?? []
        if includePrivacyManifest {
            res.append(.copy("Resources/PrivacyInfo.xcprivacy"))
        }
        return .target(
            name: varioqubTarget.name,
            dependencies: dependencies.map(\.dependency) + externalDependencies.map(\.targetDependency),
            path: varioqubTarget.path,
            resources: res,
            swiftSettings: swiftCompilerSettings
        )
    }
    
    static func testTarget(
        varioqubTarget: VarioqubTarget,
        dependencies: [VarioqubTarget] = [],
        externalDependencies: [ExternalTargetDependency] = []
    ) -> Target {
        let allDeps = [varioqubTarget.dependency] + dependencies.map(\.dependency) + externalDependencies.map(\.targetDependency)
        return .testTarget(
            name: varioqubTarget.testsName,
            dependencies: allDeps,
            path: varioqubTarget.testsPath,
            swiftSettings: swiftCompilerSettings
        )
    }
    
}

extension Package.Dependency {
    static func package(id: String, version: DependencyVersion) -> Package.Dependency {
        switch version {
        case .exact(let v):
            return .package(id: id, exact: v)
        case .range(let r):
            return .package(id: id, r)
        case .from(let v):
            return .package(id: id, from: v)
        }
    }
    
    static func package(url: String, version: DependencyVersion) -> Package.Dependency {
        switch version {
        case .exact(let v):
            return .package(url: url, exact: v)
        case .range(let r):
            return .package(url: url, r)
        case .from(let v):
            return .package(url: url, from: v)
        }
    }
}

enum DependencyVersion {
    case exact(Version)
    case range(Range<PackageDescription.Version>)
    case from(Version)
}

enum DependencySource {
    case local
    case regular
    case spmExternal
}
