#
# Be sure to run `pod lib lint Cero.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Cero"
  s.version          = "0.1.0"
  s.summary          = "HTML like views for iOS"
  s.description      = <<-DESC
                       DESC
  s.homepage         = "https://github.com/bright/Cero"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Piotr Mionskowski" => "piotr.mionskowski@brightinventions.pl" }
  s.source           = { :git => "https://github.com/bright/Cero.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/bright'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes', 'Pod/Classes/Handlers'
  s.resource_bundles = {
    # 'Cero' => []
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
  s.ios.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
