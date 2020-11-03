
Pod::Spec.new do |spec|
  spec.name         = "TFY_Navigation"

  spec.version      = "2.5.6"

  spec.summary      = "多变颜色导航栏"

  spec.description  = "字体，背景颜色，大小，横竖屏随意改。"

  spec.homepage     = "https://github.com/13662049573/TFY_Navigation"

  spec.license      = "MIT"
 
  spec.author       = { "tianfengyou" => "420144542@qq.com" }

  spec.platform     = :ios, "10.0"

  spec.source       = { :git => "https://github.com/13662049573/TFY_Navigation.git", :tag => spec.version}

  spec.source_files  = "TFY_Navigation/TFY_Navigation/TFY_Navigation.h"
  
  spec.subspec 'TFY_NavControoler' do |ss|

     ss.subspec 'TFY_CategoryConfigure' do |s|
      s.source_files = "TFY_Navigation/TFY_Navigation/TFY_NavControoler/TFY_CategoryConfigure/**/*.{h,m}"
     end 

     ss.subspec 'TFY_NavBasVcKit' do |s|
      s.source_files = "TFY_Navigation/TFY_Navigation/TFY_NavControoler/TFY_NavBasVcKit/**/*.{h,m}"
      s.dependency "TFY_NavControoler/TFY_CategoryConfigure"
     end 

     ss.subspec 'TFY_NavigationKit' do |s|
      s.source_files = "TFY_Navigation/TFY_Navigation/TFY_NavControoler/TFY_NavigationKit/**/*.{h,m}"
      s.dependency "TFY_NavControoler/TFY_CategoryConfigure"
     end 

  end

  spec.subspec 'TFY_PageController' do |ss|
   ss.source_files  = "TFY_Navigation/TFY_Navigation/TFY_PageController/**/*.{h,m}"
  end

  spec.resources     = "TFY_Navigation/TFY_Navigation/TFY_NavigationImage.bundle"
  
  spec.frameworks    = "Foundation","UIKit"

  spec.xcconfig      = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include" }
  
  spec.requires_arc = true
end
