Pod::Spec.new do |s|
  s.name     = 'DebugLog'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'A tool of debug log'
  s.homepage = 'https://github.com/liuyufeng2014/DebugLog'
 #  s.social_media_url = 'https://twitter.com/AFNetworking'
  s.author  = { 'liuyufeng2014' => 'lyf13629369104@163.com' }
  s.source   = { :git => 'https://github.com/liuyufeng2014/DebugLog.git', :tag => s.version.to_s }
  s.requires_arc = true
  s.frameworks = 'Foundation','CoreGraphics','UIKit'

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

 # s.subspec 'Security' do |ss|
  #  ss.source_files = 'AFNetworking/AFSecurityPolicy.{h,m}'
  #  ss.frameworks = 'Security'
 # end

 # s.subspec 'Reachability' do |ss|
   # ss.source_files = 'AFNetworking/AFNetworkReachabilityManager.{h,m}'
   # ss.frameworks = 'SystemConfiguration'
  # end

  # s.subspec 'NSURLConnection' do |ss|
  #  ss.dependency 'AFNetworking/Serialization'
  #  ss.dependency 'AFNetworking/Reachability'
  #  ss.dependency 'AFNetworking/Security'

   # ss.source_files = 'AFNetworking/AFURLConnectionOperation.{h,m}', 'AFNetworking/AFHTTPRequestOperation.{h,m}', 'AFNetworking/AFHTTPRequestOperationManager.{h,m}'
#  end

 # s.subspec 'NSURLSession' do |ss|
 #   ss.dependency 'AFNetworking/NSURLConnection'

 #   ss.source_files = 'AFNetworking/AFURLSessionManager.{h,m}', 'AFNetworking/AFHTTPSessionManager.{h,m}'
 #  end

 # s.subspec 'UIKit' do |ss|
 #   ss.ios.deployment_target = '6.0'

  #  ss.dependency 'AFNetworking/NSURLConnection'
  #  ss.dependency 'AFNetworking/NSURLSession'

  #  ss.ios.public_header_files = 'UIKit+AFNetworking/*.h'
  #  ss.ios.source_files = 'UIKit+AFNetworking'
  #  ss.osx.source_files = ''
  #  end
end
