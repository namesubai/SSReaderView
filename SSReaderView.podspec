

Pod::Spec.new do |s|
  s.name         = "SSReaderView"
  s.version      = "0.0.1"
  s.summary      = "A reader view for novel"
  s.platform     = :ios, "9.0"
  s.swift_versions = "5.0"
  s.homepage     = "https://github.com/namesubai/SSReaderView.git"
  s.author             = { "subai" => "804663401@qq.com" }
  s.source       = { :git => "https://github.com/namesubai/SSReaderView.git", :tag => "#{s.version}"}
  s.license      = "MIT"
  s.source_files = 'Sources/SSReaderView/*.{swift}'
  s.requires_arc = true

end
