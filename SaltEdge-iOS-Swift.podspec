#
# Be sure to run `pod lib lint saltedge-ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SaltEdge-iOS-Swift'
  s.version          = '3.2.2'
  s.summary          = "A handful of classes to help you interact with the Salt Edge API from your iOS or macOS app."
  s.description      = <<-DESC
                   SaltEdge-iOS is a library targeted at easing the interaction with the [Salt Edge API](https://docs.saltedge.com/).
                   The library aims to come in handy with some core API requests such as connecting a connection, fetching accounts/transactions, et al.
                   DESC

  s.homepage         = 'https://github.com/saltedge/saltedge-ios-swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'SaltEdge'
  s.source           = { :git => 'https://github.com/saltedge/saltedge-ios-swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.swift_version = '5'
  s.module_name = 'SaltEdge'
  s.dependency 'TrustKit'

  s.source_files = 'saltedge-ios-swift/Classes/**/*'
end
