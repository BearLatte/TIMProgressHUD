Pod::Spec.new do |s|
  s.name             = 'TIMProgressHUD'
  s.version          = '1.0.0'
  s.summary          = 'Swift 非常好用的指示器小控件，支持自定义动画'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/BearLatte/TIMProgressHUD'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tim' => 'TOPshuaiyeai@163.com' }
  s.source           = { :git => 'https://github.com/BearLatte/TIMProgressHUD.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.swift_version    = '5.0'

  s.source_files = 'TIMProgressHUD/Classes/**/*'
  
  s.resource_bundles = {
    'TIMProgressHUD' => ['TIMProgressHUD/Assets/*']
  }
end
