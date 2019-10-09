Pod::Spec.new do |s|
  s.name             = 'CampcotCollectionView'
  s.version          = '0.0.4'
  s.summary          = 'CapmcotCollectionView is custom UICollectionView that allows to expand and collapse sections.'
  s.description      = 'This library provides a custom UICollectionView that allows to expand and collapse sections.'   \
                       'It provides a simple API to manage collection view appearance.'
  s.homepage         = 'https://github.com/touchlane/CampcotCollectionView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Touchlane LLC' => 'tech@touchlane.com' }
  s.source           = { :git => 'https://github.com/touchlane/CampcotCollectionView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'Source/*.swift'
end
