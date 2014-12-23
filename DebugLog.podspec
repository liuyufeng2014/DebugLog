P:pod::Spec.new do |s|
  s.name     = 'DebugLog'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'A tool of debug log'
  s.homepage = 'https://github.com/liuyufeng2014/DebugLog'
 #  s.social_media_url = 'https://twitter.com/AFNetworking'
  s.author  = { 'liuyufeng2014' => '391868398@qq.com' }
  s.source   = { :git => 'https://github.com/liuyufeng2014/DebugLog.git', :tag => s.version.to_s }
  s.requires_arc = true
#  s.frameworks = 'Foundation','CoreGraphics','UIKit'

 # s.ios.deployment_target = '6.0'
 # s.osx.deployment_target = '10.8'

 # s.public_header_files = 'DebugLog/*.h'
 # s.source_files = 'DebugLog/DebugLog.h'
   s.source_files = 'DebugLog/DebugLog/*'
 # s.subspec 'Serialization' do |ss|
  #  ss.source_files = 'AFNetworking/AFURL{Request,Response}Serialization.{h,m}'
   # ss.ios.frameworks = 'MobileCoreServices', 'CoreGraphics'
   # ss.osx.frameworks = 'CoreServices'
 # end

 
end
