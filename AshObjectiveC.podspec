Pod::Spec.new do |spec|
  spec.name         = 'AshObjectiveC'
  spec.version      = '1.0.0'
  spec.license      =  :type => 'MIT'
  spec.homepage     = 'https://github.com/igorkravchenko/AshObjectiveC'
  spec.authors      =  'Igor Kravchenko' => 'igman2005@gmail.com'
  spec.summary      = 'Objective-C port of Ash (ActionScript 3 entity systems framework for game development created and updated by Richard Lord)'
  spec.source_files = 'AshObjectiveC/library/**'
  spec.requires_arc = true
end