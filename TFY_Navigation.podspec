
Pod::Spec.new do |spec|
  spec.name         = "TFY_Navigation"
  spec.version      = "2.1.2"
  spec.summary      = "多变颜色导航栏"

  spec.description  = "字体，背景颜色，大小，横竖屏随意改。"

  spec.homepage     = "https://github.com/13662049573/TFY_Navigation"

  spec.license      = "MIT"
 
  spec.author       = { "tianfengyou" => "420144542@qq.com" }

  spec.platform     = :ios, "10.0"

  spec.source       = { :git => "https://github.com/13662049573/TFY_Navigation.git", :tag => spec.version}

  spec.source_files  = "TFY_Navigation/TFY_Navigation/TFY_Navigation.h", "TFY_Navigation/TFY_Navigation/**/*.{h,m}"
  
  spec.frameworks    = "Foundation","UIKit"

  spec.xcconfig      = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include" }
  
  spec.requires_arc = true
end
