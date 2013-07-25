platform :ios, :deployment_target => '5.1'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'Supporting Files/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end

target :UnitTests do
	pod 'OCMock', '~> 2.0.1'
	pod 'Kiwi', '~> 2.1'
end

target :ApplicationTests, :exclusive => true do
	pod 'OCMock', '~> 2.0.1'
	pod 'Kiwi', '~> 2.1'
end

pod 'AFNetworking', '1.3.1' 
pod 'AWSiOSSDK/S3', '1.6'
pod 'JSONKit', '1.4', :inhibit_warnings => true
pod 'FlurrySDK', '4.2.2'
pod 'SSKeychain', '0.1.4'
pod 'SVPullToRefresh', '0.4.1'
pod 'QNDAnimations', '2.0.1'
pod 'CocoaLumberjack', '1.6.2'
pod 'MBProgressHUD', '0.6'
