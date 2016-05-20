#
# Be sure to run `pod lib lint DoupQueue.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DoupQueue"
  s.version          = "0.1.0"
  s.summary          = "DoupQueue is download and upload queue manager."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
DoupQueue is a download and upload queue manager. It supports download and upload cancellation at any time. It will provide a token id to do further actions.
                       DESC

  s.homepage         = "https://github.com/milankamilya/DoupQueue"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Milan Kamilya" => "milan.kamilya@innofied.com" }
  #s.source           = { :git => "https://github.com/milankamilya/DoupQueue.git", :tag => s.version.to_s }
  s.source           = { :git => "https://github.com/milankamilya/DoupQueue.git" }
  s.social_media_url = 'https://twitter.com/Milan_Kamilya'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DoupQueue/Classes/**/*'
  
  # s.resource_bundles = {
  #   'DoupQueue' => ['DoupQueue/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Alamofire', '~> 3.4'
end
