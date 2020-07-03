# Legacy support
If your App doesn't comply with the system version [requirements](/README.md#requirements), no worries: you can still use _SwiftUIPager_. 

All you need to do is:
- Install the framework as specified in the following sections.
- Add `SwiftUI` to your target's _Link Binary With Libraries_ phase and make it optional.
<img src="/resources/installation/legacy-linking.png" alt="Legacy projects with SPM" width="653" />

- Wrap any reference to `Pager` with `if #available(iOS 13, *)` or any other platform and version you may require.

## Cocoapods
```ruby
pod 'SwiftUIPager', :git => 'https://github.com/fermoya/SwiftUIPager.git', :branch => 'legacy-projects'
```

## Swift Package Manager
* File ⭢ Swift Packages ⭢ Add Package Dependency...
* Use the URL https://github.com/fermoya/SwiftUIPager.git
* **IMPORTANT:** Select branch _legacy-projects_

<img src="/resources/installation/legacy-spm-1.png" alt="Legacy projects with SPM" width="728" />
<img src="/resources/installation/legacy-spm-2.png" alt="Legacy projects with SPM" width="208" />

## Carthage
```swift
github "fermoya/SwiftUIPager" "legacy-projects"

```

## Manually
Please, refer to [manual installation](/README.md#manually).
