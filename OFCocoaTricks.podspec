Pod::Spec.new do |spec|
  spec.name             = "OFCocoaTricks"
  spec.version          = "0.0.1"
  spec.license          = { :type => 'MIT' }
  spec.homepage         = "https://github.com/OpenFibers/OFCocoaTricks"
  spec.summary          = "OFCocoaTricks is combination of objective-c runtime tools."
  spec.description      = "OFCocoaTricks is combination of objective-c runtime tools."

  spec.author           = { "OpenFibers" => "openfibers@gmail.com" }
  spec.source           = { :git => "https://github.com/OpenFibers/OFCocoaTricks", :branch => 'master'}
  spec.source_files  = "OFRuntimeTools/**/*.{h,m}"
  #spec.public_header_files = "OFRuntimeTools/private/**/*.h"
  spec.frameworks = 'Foundation', 'UIKit'

  spec.platform     = :ios, '8.0'
  spec.ios.deployment_target = '8.0'
  spec.requires_arc = true
end
