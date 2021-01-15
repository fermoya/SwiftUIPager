`SwiftUIPager` stops supporting a binding in its initializer and will take a `Page` instead. This allows `Pager` to move even more smoothly than before. Use one of the convenience method to initialize a new `Page`: `firstPage()` or `withIndex(_:)`. It's not required but if modifying the page `index` was need then the object must be wrapped into `StateObject` or `ObservedObject` depending on the needs.

### Features
- New modifier `onPageWillChange`

### Fixes
- #170 Page index resetting in nested `Pager`
- #172 Pages don't seem to be clipped
- Fixed `onPageChanged` call too many times and before animation is over

