Pod::Spec.new do |s|

  s.name         = "BKCountDownTimer"
  s.version      = "0.0.1"
  s.summary      = "Circle shaped countdown timer."
  s.description  = <<-DESC
Circle shaped countdown timer. With Swift
                   DESC

  s.homepage     = "https://github.com/bugkingK/BKCountDownTimer"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "bugkingK" => "myway0710@naver.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/bugkingK/BKCountDownTimer.git", :tag => "#{s.version}" }
  s.source_files = "Classes", "BKCountDownTimer/Sources/**/*.{swift}"

  s.swift_version = '5.0'	

end