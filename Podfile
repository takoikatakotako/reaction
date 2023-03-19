# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def install_pods
  use_frameworks!
  inhibit_all_warnings!

  pod 'Firebase'
	pod 'FirebaseAnalytics'
  pod 'FirebaseRemoteConfig'
  pod 'FirebaseMessaging'	
  pod 'Google-Mobile-Ads-SDK'
  pod 'SwiftLint'
  pod 'SDWebImageSwiftUI'
  pod 'KeychainAccess'
end

target 'ReactionLocal' do
  install_pods
  
  target 'ReactionTests' do
    inherit! :search_paths
  end

  target 'ReactionUITests' do
    inherit! :search_paths
  end
end

target 'ReactionStaging' do
  install_pods
end

target 'ReactionProduction' do
  install_pods
end
