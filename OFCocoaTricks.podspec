Pod::Spec.new do |spec|
  spec.name             = "OFCocoaTricks"
  spec.version          = "0.0.1"
  spec.license          = { :type => 'MIT' }
  spec.homepage         = "https://github.com/OpenFibers/OFCocoaTricks"
  spec.summary          = "A combination of objective-c runtime tool."
  spec.description      = "A combination of objective-c runtime tool."

  spec.author           = { "OpenFibers" => "openfibers@gmail.com" }
  spec.source           = { :git => "https://github.com/OpenFibers/OFCocoaTricks.git", :tag => spec.version.to_s }
  spec.source_files  = "OFRuntimeTools/**/*.{h,m}"
  spec.frameworks = 'Foundation', 'UIKit'

  spec.platform     = :ios, '8.0'
  spec.ios.deployment_target = '8.0'
  spec.requires_arc = true
end