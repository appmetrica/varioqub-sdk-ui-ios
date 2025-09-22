Pod::Spec.new do |s|

  s.name = "VarioqubUI"
  s.version = '1.1.1'
  s.summary = "VarioqubUI"

  s.homepage = "https://varioqub.ru"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.authors = { "AppMetrica" => "admin@appmetrica.io" }
  s.ios.deployment_target = '13.0'
  s.source = { :git => "https://github.com/appmetrica/varioqub-sdk-ui-ios.git", :tag=>s.version.to_s }

  s.swift_versions = "5.8"
  s.pod_target_xcconfig = {
      'APPLICATION_EXTENSION_API_ONLY' => 'YES',
      'DEFINES_MODULE' => 'YES',
      'OTHER_SWIFT_FLAGS' => '$(inherited) -DVQ_LOGGER',
  }

  s.frameworks = 'Foundation'

  s.default_subspec = 'Core'

  s.subspec "Core" do |core|
    core.source_files = [
      "Sources/VarioqubUI/**/*.swift",
    ]

    core.dependency 'Varioqub', "= #{s.version}"
    core.dependency 'DivKit', '>= 32.9.0'
  end

end
