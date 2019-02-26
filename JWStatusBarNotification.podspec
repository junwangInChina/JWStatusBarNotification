#
#  Be sure to run `pod spec lint JWStatusBarNotification.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  
  s.name         = "JWStatusBarNotification"
  s.version      = "0.0.1"
  s.summary      = "通知栏消息展示"

  #主页
  s.homepage     = "https://github.com/junwangInChina/JWStatusBarNotification"
  #证书申明
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  #作者
  s.author       = { "wangjun" => "github_work@163.com" }
  #支持版本
  s.platform     = :ios, "9.0"
  #项目地址，版本
  s.source       = { :git => "https://github.com/junwangInChina/JWStatusBarNotification.git", :tag => s.version }

  #库文件路径
  s.source_files  = "JWStatusBarNotification/JWStatusBarNotification/JWStatusBarNotification/**/*.{h,m}"
  #资源文件
  #s.resource      = ""
  #是否ARC
  s.requires_arc = true

end
