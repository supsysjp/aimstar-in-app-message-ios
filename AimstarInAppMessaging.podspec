#
# Be sure to run `pod lib lint AimstarInAppMessaging.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'AimstarInAppMessaging'
  s.module_name      = 'AimstarInAppMessagingSDK'
  s.version          = '1.0.2'
  s.summary          = 'AimstarInAppMessaging'
  s.description      = 'AimstarInAppMessaging SDK'
  s.homepage         = 'https://github.com/supsysjp/aimstar-in-app-message-ios'
  s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
  s.author           = 'Supreme System Co., Ltd.'
  s.ios.deployment_target = '13.0'
  s.swift_versions = ['5.6']
  s.source = { :http => "https://github.com/supsysjp/aimstar-in-app-message-ios/releases/download/#{s.version.to_s}/AimstarInAppMessagingSDK.zip" }
  s.vendored_frameworks = 'AimstarInAppMessagingSDK.xcframework'
end
