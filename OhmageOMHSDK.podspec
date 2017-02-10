#
# Be sure to run `pod lib lint OhmageOMHSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OhmageOMHSDK'
  s.version          = '0.0.7'
  s.summary          = 'OhmageOMHSDK is data uploader for ohmage-OMH.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
OhmageOMHSDK is data uploader for [ohmage-OMH](https://github.com/smalldatalab/omh-dsu).
**This project is currently experimental and will be changing rapidly. You probably shouldn't use it yet!**
                       DESC

  s.homepage         = 'https://github.com/cornelltech/OhmageOMHSDK-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => "Apache 2", :file => "LICENSE" }
  s.author           = { "James Kizer, Cornell Tech Foundry" => "jdk288 at cornell dot edu" }
  s.source           = { :git => 'https://github.com/cornelltech/OhmageOMHSDK-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.subspec 'Core' do |core|
    core.source_files = 'Source/Core/**/*'
    core.dependency 'OMHClient', '~> 0.0'
    core.dependency 'SecureQueue', '~> 0.0'
    core.dependency 'Alamofire', '~> 4'
  end

  s.subspec 'RKSupport' do |rks|
    rks.source_files = 'Source/RKSupport/**/*'
    rks.dependency 'OhmageOMHSDK/Core'
    rks.dependency 'ResearchKit', '~> 1.3.1'
  end

  s.subspec 'RSRPSupport' do |rsrp|
    rsrp.source_files = 'Source/RSRPSupport/**/*'
    rsrp.dependency 'OhmageOMHSDK/Core'
    rsrp.dependency 'ResearchSuiteResultsProcessor'
  end

  s.default_subspec = 'Core'

end
