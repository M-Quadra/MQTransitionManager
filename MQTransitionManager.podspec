Pod::Spec.new do |spec|
  spec.name         = "MQTransitionManager"
  spec.version      = "0.0.3"
  spec.summary      = "a transition manager for UINavigationController"
  spec.description  = <<-DESC
  a transition manager for UINavigationController
                   DESC

  spec.homepage = "https://github.com/M-Quadra/MQTransitionManager"
  spec.license  = { :type => "MIT", :file => "LICENSE" }
  spec.author   = "M_noAria"

  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/M-Quadra/MQTransitionManager.git", :tag => spec.version.to_s }
  spec.source_files = "MQTransitionManager", "MQTransitionManager/MQTransitionManager/**/*.{h,m}"

  spec.frameworks = 'UIKit'
  spec.dependency "FDFullscreenPopGesture"
  
end
