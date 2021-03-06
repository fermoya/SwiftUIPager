### Features
- New `interactive(opacity:)` to add an interactive fade in/out effect to the scroll
- New `interactive(scale:)` and `interactive(rotation:)`
- Interactive effects can be now combined
- CI/CD to build `legacy-projects` branch against _iOS 12_

### Fixes
- Items not scrolling in _iOS 13_ 
- #193 Transitions are jumpy if fast
- #194 `AnimatableModifier` symbol not found

### Deprecations
- `rotation3D()` in favor of `interactive(rotation:)`
- `interactive(_:)` in favor of `interactive(scale:)`