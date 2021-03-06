#
# Be sure to run `pod lib lint SnapConstraints.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SnapConstraints'
  s.version          = '1.0.5'
  s.summary          = 'A lightweight library for working with constraints programatically.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ALL YOU NEED TO DO IS .snap ;). Now working with Swift 4.

# Useful information ahead:

- Constraints are added as soon as they are created. 
* Views who are subject to SnapConstraints have .translatesAutoresizingMaskIntoConstraints set to false automatically.
- This framework is optimized to hide as many negative values as possible. If a constraint is not shown properly, try setting the constant as a negative value, and maybe check if you are using the correct type of SnapConstraint. 
* The SnapManager contains internal logging and SnapConstraints options. Please modify as you wish.
- The framework is build around SnapConstraintTypes and constraints can be created by accessing any child of UIView, and using the variable '.snap' to initiate the chaining of constraints and mask. Yup, chaining and masks, you heard right.
* All constraints created can be retrieved immediately by using the .snaps methods on the view they are added to. 

                       DESC

  s.homepage         = 'https://github.com/sbrighiu/SnapConstraints'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Apache License 2.0', :file => 'LICENSE' }
  s.author           = { 'Stefan M. Brighiu (SMBCheeky)' => 'sbrighiu@gmail.com' }
  s.source           = { :git => 'https://github.com/sbrighiu/SnapConstraints.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SnapConstraints/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SnapConstraints' => ['SnapConstraints/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

# echo "4.2" > .swift-version
# Check lint:   pod spec lint SnapConstraints.podspec
# add tag with version
# push
# pod trunk register smbcheeky@gmail.com
# Push:         pod trunk push

