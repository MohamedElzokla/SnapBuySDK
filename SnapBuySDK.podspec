Pod::Spec.new do |s|
  s.name             = 'SnapBuySDK'
  s.version          = '1.0.0'
  s.summary          = 'SDK for snapbuy APIs.'

  s.description      = 'objective C SDK for snapbuy APIs.'

  s.homepage         = 'https://github.com/MohamedElzokla/snapbuySDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MohamedElzokla' => 'mohamed.elzokla@yahoo.com' }
  s.source           = { :git => 'https://github.com/MohamedElzokla/snapbuySDK.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = 'SnapBuySDK/snapbuy/*','SnapBuySDK/snapbuy/HTTP Client/*'

end