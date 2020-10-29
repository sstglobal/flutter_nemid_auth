#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
#
Pod::Spec.new do |s|
  s.name             = 'nemid_auth'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin to integrate the nemid libraries for iOS and Android.'
  s.description      = <<-DESC
                        A new Flutter plugin
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.resource_bundles = {
    'nemid_bundle' => ['Classes/**/*.{xib,fsh,vsh,xcassets,storyboard}']
  }

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
