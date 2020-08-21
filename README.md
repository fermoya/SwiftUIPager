# SwiftUIPager

![CI](https://github.com/fermoya/SwiftUIPager/workflows/Unit%20Tests/badge.svg)
[![codecov](https://codecov.io/gh/fermoya/SwiftUIPager/branch/develop/graph/badge.svg)](https://codecov.io/gh/fermoya/SwiftUIPager)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Cocoapods](https://img.shields.io/cocoapods/v/SwiftUIPager.svg)](https://cocoapods.org/pods/SwiftUIPager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods platforms](https://img.shields.io/cocoapods/p/SwiftUIPager.svg)](https://cocoapods.org/pods/SwiftUIPager)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

_SwiftUIPager_ provides  a `Pager` component built with SwiftUI native components. `Pager` is a view that renders a scrollable container to display a handful of pages. These pages are recycled on scroll, so you don't have to worry about memory issues. `Pager` will load just a handful of items, enough to beatifully scroll along.

Create vertical or horizontal pagers, align the cards, change the direction of the scroll, animate the pagintation... `Pager` lets you do anything you want.

- [Requirements](#requirements)
- [Installation](#installation)
    - [Cocoapods](#cocoapods)
    - [Swift Package Manager](#swift-package-manager)
    - [Carthage](#carthage)
    - [Manually](#manually)
- [Legacy projects support](Documentation/Legacy.md)
- [Usage](Documentation/Usage.md)
    - [Initialization](Documentation/Usage.md#initialization)
    - [UI customization](Documentation/Usage.md#ui-customization)
        - [Configure your page size](Documentation/Usage.md#configure-your-page-size)
        - [Orientation and direction](Documentation/Usage.md#orientation-and-direction)
        - [Alignment](Documentation/Usage.md#alignment)
        - [Multiple pagination](Documentation/Usage.md#multiple-pagination)
    - [Paging Priority](Documentation/Usage.md#paging-priority)
    - [Animations](Documentation/Usage.md#animations)
        - [Scale](Documentation/Usage.md#scale)
        - [Rotation](Documentation/Usage.md#rotation)
        - [Loop](Documentation/Usage.md#loop)
    - [Add pages on demand](Documentation/Usage.md#add-pages-on-demand)
    - [Content Loading Policy](Documentation/Usage.md#content-loading-policy)
    - [Examples](Documentation/Usage.md#examples)
- [Known Issues](#known-issues)
- [Feedback](#feedback)
- [Support Open Source](#support-open-source)
- [License](#license)

<img src="resources/usage/example-of-usage.gif" alt="Example of usage"/>
        
## Requirements
* iOS 13.0+
* macOS 10.15+
* watchOS 6.0+
* tvOS 13.0+
* Swift 5.1+

## Installation

### CocoaPods
```ruby
pod 'SwiftUIPager'
```
### Swift Package Manager

In Xcode:
* File ⭢ Swift Packages ⭢ Add Package Dependency...
* Use the URL https://github.com/fermoya/SwiftUIPager.git

### Carthage

```swift
github "fermoya/SwiftUIPager"
```

### Manually
* Download _[SwiftUIPager.xcframework](SwiftUIPager.xcframework)_
* Create a group _Frameworks_ inside your project and drag and drop _SwiftUIPager.xcframework_
<img src="resources/installation/manual-installation-step-1.png" alt="Manual Installation Step 1" width="229"/>

* Make sure in your target's build phases that the option _Embed & Sign_ is selected:
<img src="resources/installation/manual-installation-step-2.png" alt="Manual Installation Step 2" width="755"/>

## Known Issues
* `NavigationLink` and `Button` might work oddly with `Pager` if `pagingPriority(.simultaneous)` is used in _SwiftUI 1.0_ and _iOS 13_. This issue isn't reproducible in _iOS 14 beta_. For more information, follow this [link](https://stackoverflow.com/questions/58440469/swiftui-navigationlink-and-scrollview-drag-gesture-colliding).
* Depending on the _Xcode_ version, you might run into a precondition failure affecting _SwiftUI 1.0_ and _iOS 13_. This issue doesn't occur on _Xcode 12 beta_. For more information about workarounds, see _Precondition failure: invalid value type for attribute [#60](https://github.com/fermoya/SwiftUIPager/issues/60)_.

## Feedback
If you happen to encounter any problem or you have any suggestion, please, don't hesitate to open an issue or reach out to me at [fmdr.ct@gmail.com](mailto:fmdr.ct@gmail.com).  
This is an open source code project, so feel free to collaborate by raising a pull-request or sharing your feedback. 

## Support Open Source

If you love this library, understand all the effort it takes to maintain it and would like to  support me, you can buy me a coffee by following this [link](https://www.buymeacoffee.com/fermoya):

<a href="https://www.buymeacoffee.com/fermoya" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>

You can also sponsor me by hitting the [_GitHub Sponsor_](https://github.com/sponsors/fermoya) button. All help is very much appreciated.

## License  

`SwiftUIPager` is available under the MIT license. See the [LICENSE](/LICENSE) file for more info.
