Pod::Spec.new do |s|

  s.name         = "CocoaAnalyzer"
  s.version      = "0.4.1"
  s.summary      = "Tool for finding xib and storyboard-related issues at the build time."

  s.homepage     = "https://github.com/banggaoo/CocoaAnalyzer"
  s.license      = "MIT"
  s.author       = { "James Lee" => "jameslee@goodeffect.com" }

  s.source       = { :git => 'https://github.com/banggaoo/CocoaAnalyzer.git', :tag => s.version.to_s }

  s.preserve_paths = '*'

end
