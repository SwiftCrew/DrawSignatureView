# DrawSignatureView
DrawSignatureView is a simple, light-weight drawing framework written in Swift. Its very easy to implement. 


# DrawSignatureView

Signature component for iOS written in Swift

[![Platform](https://img.shields.io/cocoapods/p/DrawSignatureView.svg?style=flat)](http://cocoapods.org/pods/DrawSignatureView)
[![Swift 4.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Version](https://img.shields.io/cocoapods/v/DrawSignatureView.svg?style=flat)](https://cocoapods.org/?q=DrawSignatureView)

## Requirements
* iOS 9.0+
* Swift 5.0

### Installation

##### [CocoaPods](http://cocoapods.org)

DrawSignatureView is available through CocoaPods. To install it, simply add the following line to your Podfile:
```ruby
pod "DrawSignatureView"
```

## Usage

Using DrawSignatureView is very simple:

### Getting Started:

If you have installed via Cocoapods, you will need to import the module into your Swift file:

    import DrawSignatureView

Create a DrawSignatureView either through interface builder, or through code:

    let drawSignatureView = DrawSignatureView(frame: frame)
    self.view.addSubview(drawSignatureView)


#### Methods

Clears signature

* `erase()`

#### CallBack
  
  * you willl get the current touchState
  
         self.drawSignatureView.currentTouchState = { [weak self] (touchState) in
           switch touchState {
           case .began:
             print("began")
           case .moved:
             print("moved")
           case .ended:
             print("ended")
           case .none:
             print("none")
           }
         }

