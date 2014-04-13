platform :ios, :deployment_target => '7.0'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'Supporting Files/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end

target :UnitTests do
	pod 'OCMock', '~> 2.2.3'
	pod 'Kiwi', '~> 2.2.0'
end

target :ApplicationTests, :exclusive => true do
	pod 'OCMock', '~> 2.2.3'
	pod 'Kiwi', '~> 2.2.0'
end

pod 'AFNetworking', '2.2.1' 
pod 'AWSiOSSDK/S3', '1.7.1'
pod 'FlurrySDK', '4.4.0'
pod 'SSKeychain', '1.2.2'
pod 'MBProgressHUD', '0.8.0'
pod 'QNDAnimations', '2.0.1'
pod 'CocoaLumberjack', '1.8.1'
pod 'FormatterKit/TimeIntervalFormatter', '1.4.2'
