Pod::Spec.new do |s|
  s.name         = "AshObjectiveC"
  s.version      = "1.0.0"
  s.summary      = "Objective-C port of Ash (ActionScript 3 entity system framework for game development)"
  s.description  = <<-DESC
                   http://www.ashframework.org/
                   DESC
  s.homepage     = "https://github.com/igorkravchenko/AshObjectiveC"
  s.license      = 'MIT'
  s.author             = { "Igor Kravchenko" => "igman2005@gmail.com" }
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/igorkravchenko/AshObjectiveC.git", :tag => "1.0.0" }
  s.source_files = 'AshObjectiveC/library', 'AshObjectiveC/library/**/*.{h,m}'
  s.requires_arc = true
  s.framework = 'CoreGraphics, UIKit, QuartzCore'
end
