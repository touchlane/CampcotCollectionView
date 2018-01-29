Pod::Spec.new do |s|
  s.name             = 'CampcotCollectionView'
  s.version          = '0.0.1'
  s.summary          = 'UICollectionViewLayout extension to expand and collapse sections.'
  s.description      = <<-DESC
  Expand or collapse sections of UICollectionView.
                       DESC
  s.homepage         = 'https://github.com/touchlane/CampcotCollectionView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Touchlane LLC' => 'tech@touchlane.com' }
  s.source           = { :git => 'https://github.com/touchlane/CampcotCollectionView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'Source/*.swift'
end
