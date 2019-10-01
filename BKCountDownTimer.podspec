Pod::Spec.new do |s|

  s.name         = "BKCountDownTimer"
  s.version      = "1.0.0"
  s.summary      = "Circle shaped countdown timer."
  s.description  = <<-DESC
Circle shaped countdown timer. With Swift
                   DESC

  s.homepage     = "https://github.com/bugkingK/CountDownTimer"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "bugkingK" => "myway0710@naver.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/bugkingK/CountDownTimer.git", :tag => "#{s.version}" }
  s.source_files = "Classes", "Sources/**/*.{swift}"

  s.swift_version = '5.0'	

end