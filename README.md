# [Varioqub UI SDK](https://varioqub.ru)

Varioqub UI SDK allows is a solution from Yandex for managing a digital Product and conducting A/B tests.

## Installation

### Swift Package Manager

#### Through Xcode:

1. Go to **File** > **Add Package Dependency**.
2. Put the GitHub link of the Varioqub UI SDK: https://github.com/appmetrica/varioqub-sdk-ui-ios.
3. In **Add to Target**, select **None** for modules you don't want.

#### Via Package.swift Manifest:

1. Add the SDK to your project's dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/appmetrica/varioqub-sdk-ui-ios", from: "1.0.0"),
],
```

2. List the modules in your target's dependencies:

```swift
.target(
    name: "YourTargetName",
    dependencies: [
        .product(name: "VarioqubUI", package: "varioqub-sdk-ui-ios"),
    ]
)
```

### CocoaPods

1. If you haven't set up CocoaPods, run `pod init` in your project directory.
2. In your Podfile, add Varioqub UI dependencies:

```ruby
target 'YourAppName' do
    pod 'VarioqubUI', '~> 1.0.0'
end
```

3. Install the dependencies using `pod install`.
4. Open your project in Xcode with the `.xcworkspace` file.

## Documentation

You can find comprehensive integration details and instructions for installation, configuration, testing, and more in our [full documentation](https://yandex.com/support/varioqub-app/en/sdk/ios/integration-ui).

## License

Varioqub UI SDK is released under the MIT License.
License agreement is available at [LICENSE](LICENSE).
