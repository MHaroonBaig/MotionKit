Pod::Spec.new do |s|
  s.name = 'MotionKit'
  s.version = '0.8.1'
  s.license = 'MIT'
  s.summary = 'CoreMotion Made insanely simple'
  s.homepage = 'https://github.com/MHaroonBaig/MotionKit'
  s.social_media_url = 'https://twitter.com/PyBaig'
  s.authors = { 'Haroon Baig' => 'haroon.prog@gmail.com' }
  s.source = { :git => 'https://github.com/MHaroonBaig/MotionKit.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'MotionKit/*.swift'

  s.requires_arc = true
end
