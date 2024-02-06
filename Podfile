platform :ios, '13.0'

target 'TFY_Navigation' do
  inhibit_all_warnings!
  use_frameworks!
 
  pod 'TFY_LayoutCategoryKit'
  pod 'TFY_TabBarKit'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = "NO"
        end
    end
end
