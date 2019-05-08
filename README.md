# SnapConstraints

[![Version](https://img.shields.io/cocoapods/v/SnapConstraints.svg?style=flat)](http://cocoapods.org/pods/SnapConstraints)
[![License](https://img.shields.io/cocoapods/l/SnapConstraints.svg?style=flat)](http://cocoapods.org/pods/SnapConstraints)
[![Platform](https://img.shields.io/cocoapods/p/SnapConstraints.svg?style=flat)](http://cocoapods.org/pods/SnapConstraints)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

SnapConstraints is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SnapConstraints"
```

## Description

Just use `.snap` on any UIView subclass and choose from simple options like `.bottom` , `.top`, `.below` or a bit more complex options like masks `.snap.mask([.fill])`.

To snap to the superview's safeArea use `.leadingToSafeArea`, `.topToSafeArea`, `.bottomToSafeArea`, `.trailingToSafeArea`. 
These constraints cannot be stacked or added in current masks like the rest because they are simple constraints.

All options will automatically activate the constraint/s and will return the last set constraint.

## Author

Stefan M. Brighiu (SMBCheeky), sbrighiu@gmail.com

## License

SnapConstraints is available under the Apache License 2.0 license. See the LICENSE file for more info.
