#
# Be sure to run `pod lib lint RCSceneKTVMusicKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RCSceneKTVMusicKit'
  s.version          = '0.1.0'
  s.summary          = 'RCSceneKTVMusicKit of RongCloud Scene.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
			RongCloud RCSceneKTVMusicKit SDK for iOS.
                       DESC

  s.homepage         = 'https://github.com/rongcloud-community'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license      = { :type => "Copyright", :text => "Copyright 2022 RongCloud" }
  s.author           = { '彭蕾' => 'penglei1@rongcloud.cn' }
  s.source           = { :git => 'https://github.com/rongcloud-community/rongcloud-scene-ktvmusic-kit-ios.git', :tag => s.version.to_s }

  s.social_media_url = 'https://www.rongcloud.cn/devcenter'

  s.ios.deployment_target = '11.0'
    
  s.source_files = 'RCSceneKTVMusicKit/Classes/*.h'
  
  s.subspec 'Common' do |ss|
    ss.source_files = 'RCSceneKTVMusicKit/Classes/Common/**/*'
  end
  
  s.subspec 'KTVTuner' do |ss|
    ss.dependency 'RCSceneKTVMusicKit/Common'
    
    ss.source_files = 'RCSceneKTVMusicKit/Classes/KTVTuner/**/*'
  end
  
  s.subspec 'KTVLyric' do |ss|
    ss.dependency 'RCSceneKTVMusicKit/Common'
    
    ss.source_files = 'RCSceneKTVMusicKit/Classes/KTVLyric/**/*'
  end
  
  s.subspec 'KTVScreen' do |ss|
    ss.dependency 'RCSceneKTVMusicKit/Common'
    ss.dependency 'RCSceneKTVMusicKit/KTVLyric'
    
    ss.source_files = 'RCSceneKTVMusicKit/Classes/KTVScreen/**/*'
  end
  
  s.subspec 'KTVMusicLibrary' do |ss|
    ss.dependency 'RCSceneKTVMusicKit/Common'
    ss.dependency 'RCSceneNetworkKit'
    ss.dependency 'SDWebImage'
    ss.dependency 'MJRefresh'
    
    ss.source_files = 'RCSceneKTVMusicKit/Classes/KTVMusicLibrary/**/*'
  end
  
   s.resource_bundles = {
     'RCSceneKTVMusicKit' => ['RCSceneKTVMusicKit/Assets/**/*']
   }
  
  s.dependency 'RCSceneBaseKit'
  s.dependency 'Masonry'
  s.dependency 'YYModel'
  s.dependency 'SVProgressHUD'
  
  s.prefix_header_file = 'RCSceneKTVMusicKit/Classes/Common/RCSKTVMusicPrefixHeader.pch'
  
end
