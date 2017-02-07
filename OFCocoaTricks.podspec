Pod::Spec.new do |s|
  s.name             = "OFCocoaTricks"
  s.version          = "0.0.1"

  s.description      = <<-DESC
                       OFCocoaTricks is combination of objective-c runtime tools.
                       DESC
  s.summary          = "OFCocoaTricks is combination of objective-c runtime tools."

  s.homepage         = "https://github.com/OpenFibers/OFCocoaTricks"
  s.author           = "OpenFibers"
  s.license          = { :type => 'MIT' }
  s.source           = { :git => "https://github.com/OpenFibers/OFCocoaTricks", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.subspec 'Core' do |ss|
    ss.source_files = 'OFRuntimeTools/**/*.{h,m,swift}'
    ss.frameworks = 'UIKit', 'Foundation'
  end

end
