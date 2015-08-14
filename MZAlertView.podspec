Pod::Spec.new do |s|
  s.name     = 'MZAlertView'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'A UIView like UIAlertController for IOS8'
  s.homepage = 'https://github.com/cjh0266/MZAlertView'
  s.author   = { 'MZ' => '547977702@qq.com' }
 
  s.source   = { :git => 'https://github.com/cjh0266/MZAlertView.git', :tag => "v#{s.version}" }

  s.description = %{
    A UIView like UIAlertController for IOS8
    MZAlertView supports iOS7 and laster.
  }

  s.source_files = '*'


  s.frameworks = 'Foundation', 'UIKit'

  s.ios.deployment_target = '7.0'  
  s.requires_arc = true
end
