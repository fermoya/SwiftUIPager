//
//  PagerContent+Buildable.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pager.PagerContent: Buildable {

    /// Sets the animation to be applied when the user stops dragging
    ///
    /// - Parameter value: callback to get an animation based on the result of dragging
    func pagingAnimation(_ value: ((Pager.DragResult) -> PagingAnimation)?) -> Self {
        mutating(keyPath: \.pagingAnimation, value: value)
    }

    /// Allows to page more than one page at a time.
    ///
    /// - Note: This will change `contentLoadingPolicy` to `.eager`. Modifying this value will result in an unpredictable UI.
    func multiplePagination() -> Self {
        mutating(keyPath: \.allowsMultiplePagination, value: true)
            .mutating(keyPath: \.contentLoadingPolicy, value: .eager)
    }

    /// Sets the policy followed to load `Pager` content.
    ///
    /// - Parameter value: policy to load the content.
    ///
    /// Choose `lazy` to load pages on demand so that the right amount of memory is used. Choose `eager` if
    /// `Pager` won't hold many items or if memory isn't  an issue.
    func contentLoadingPolicy(_ value: ContentLoadingPolicy) -> Self {
        mutating(keyPath: \.contentLoadingPolicy, value: value)
    }

    /// Sets `Pager` to loop the items in a never-ending scroll.
    ///
    /// - Parameter value: `true` if `Pager` should loop the pages. `false`, otherwise.
    /// - Parameter count: number of times the input data should be repeated in a looping `Pager`. Default is _1_.
    ///
    /// To have a nice experience, ensure that  the `data` passed in the intializer has enough elements to fill
    /// pages on both the screen and the sides. If your sequence is not large enough, use `count` to
    /// repeat it and pass more elements.
    func loopPages(_ value: Bool = true, repeating count: UInt = 1) -> Self {
        var newData = data
        if let id = newData.first?.keyPath {
            let count = max(1, count)
            newData = (1...count).map { it in
                data.map { PageWrapper(batchId: it, keyPath: id, element: $0.element) }
            }.flatMap { $0 }
        }
        self.pagerModel.isInfinite = value
        self.pagerModel.totalPages = newData.count
        return mutating(keyPath: \.isInifinitePager, value: value)
            .mutating(keyPath: \.data, value: newData)
    }

    /// Sets a limit to the dragging offset, affecting the pagination towards neighboring items.
    /// When the limit is reached, items won't keep scrolling further.
    /// This modifier is incompatible with `multiplePagination` and will modify its value.
    ///
    /// - Parameter ratio: max page percentage. Should be `0 < ratio < 1`
    /// - Note: This modifier is incompatible with `multiplePagination`
    ///
    /// For instance, setting this `ratio` to `0.5` will make `Pager` reveal half of the next item tops.
    func partialPagination(_ ratio: CGFloat) -> Self {
        mutating(keyPath: \.pageRatio, value: ratio)
    }

    #if !os(tvOS)

    /// User can only swipe forward so in one direction
    ///
    /// - Parameter enabled: by default dragForwardOnly is disables so pages can be scrolled in both directions,
    ///     set to true to disable scrolling backwards
    func dragForwardOnly(_ value: Bool = true) -> Self {
        mutating(keyPath: \.dragForwardOnly, value: value)
    }

    /// Sets the explicit animation to be used. Defaults to `.standard`
    ///
    /// - Parameter anim1: animation to use while dragging
    /// - Parameter anim2: animation to use to page
    ///
    /// - Note: Setting different animations could cause unexpected behavior
    /// - Warning: `spring` animations don't work well. Avoid high responses while dragging as the animation should be short
    func draggingAnimation(onChange anim1: DraggingAnimation, onEnded anim2: DraggingAnimation) -> Self {
        mutating(keyPath: \.draggingAnimation, value: anim1)
            .mutating(keyPath: \.pagingAnimation, value: { _ in anim2 })
    }

    /// Sensitivity used to determine whether or not to swipe the page
    ///
    /// - Parameter value: sensitivity to be applied when paginating
    func sensitivity(_ value: PaginationSensitivity) -> Self {
        mutating(keyPath: \.sensitivity, value: value)
    }

    /// Makes `Pager` not delay gesture recognition
    ///
    /// - Parameter value: whether or not touches should be delayed
    func delaysTouches(_ value: Bool) -> Self {
        mutating(keyPath: \.minimumDistance, value: value ? 15 : 0)
    }

    /// Sets whether the dragging is enabled or not
    ///
    /// - Parameter value: `true` if  dragging is allowed, `false`, otherwise. Defaults to `true`
    func allowsDragging(_ value: Bool = true) -> Self {
        mutating(keyPath: \.allowsDragging, value: value)
    }

    /// Sets the priority used for paging the items
    ///
    /// - Parameter value: priority to receive touches
    ///
    /// By default, touches in a page may be blocked if the they occur on top a `View` with a `Gesture`.
    /// For instance, a `NavigationLink` or a `MagnificationGesture` inside a page can "break" the swiping in `Pager`.
    /// To solve this issue, use `pagingPriority(.simultaneous)` to let the touch be received for both the page content and `Pager`.
    func pagingPriority(_ value: GesturePriority) -> Self {
        mutating(keyPath: \.gesturePriority, value: value)
    }

    /// Indicates which area should allow hits and react to swipes
    ///
    /// - Parameter value: area of interaction
    func swipeInteractionArea(_ value: SwipeInteractionArea) -> Self {
        mutating(keyPath: \.swipeInteractionArea, value: value)
    }

    /// Sets whether `Pager` should bounce or not
    func bounces(_ value: Bool) -> Self {
        mutating(keyPath: \.bounces, value: value)
    }

    /// Adds a callback to react when dragging begins. Useful for dismissing a keyboard like a scrollview
    ///
    /// - Parameter callback: block to be called when  dragging begins
    func onDraggingBegan(_ callback: (() -> Void)?) -> Self {
        mutating(keyPath: \.onDraggingBegan, value: callback)
    }

    /// Adds a callback to react when dragging changes
    ///
    /// - Parameter callback: block to be called when  dragging changes. `pageInrement` is passed as argument
    func onDraggingChanged(_ callback: ((Double) -> Void)?) -> Self {
        mutating(keyPath: \.onDraggingChanged, value: callback)
    }

    /// Adds a callback to react when dragging ends
    ///
    /// - Parameter callback: block to be called when  dragging ends. 
    func onDraggingEnded(_ callback: (() -> Void)?) -> Self {
        mutating(keyPath: \.onDraggingEnded, value: callback)
    }
  
    #endif

    /// Adds a callback to react when _iWatch Digital Crown_ is rotated
    ///
    /// - Parameter callback: block to be called when  dragging begins
    @available(iOS, unavailable)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS 7.0, *)
    func onDigitalCrownRotated(_ callback: ((Double) -> Void)?) -> Self {
        mutating(keyPath: \.onDigitalCrownRotated, value: callback)
    }

    /// Sets whether the `Pager` interacts with the _watchOS_ digital crown
    ///
    /// - Parameter value: `true` if  allowed, `false`, otherwise. Defaults to `true`
    @available(iOS, unavailable)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS 7.0, *)
    public func allowsDigitalCrownRotation(_ value: Bool = true) -> Self {
        mutating(keyPath: \.allowsDigitalCrownRotation, value: value)
    }

    /// Sets the explicit animation to be used. Defaults to `.standard`
    ///
    /// - Parameter value: animation to use while dragging and to page
    ///
    /// - Warning: `spring` animations don't work well. Avoid high responses while dragging as the animation should be short
    func draggingAnimation(_ value: DraggingAnimation) -> Self {
        mutating(keyPath: \.draggingAnimation, value: value)
    }

    /// Changes the a the  alignment of the pages relative to their container
    ///
    /// - Parameter value: alignment of the pages inside the scroll
    func alignment(_ value: PositionAlignment) -> Self {
        mutating(keyPath: \.alignment, value: value)
    }

    /// Returns a horizontal pager
    ///
    /// - Parameter swipeDirection: direction of the swipe. Defaults to `.leftToRight`
    func horizontal(_ swipeDirection: HorizontalSwipeDirection = .leftToRight) -> Self {
        let scrollDirectionAngle: Angle = swipeDirection == .leftToRight ? .zero : Angle(degrees: 180)
        return mutating(keyPath: \.isHorizontal, value: true)
            .mutating(keyPath: \.scrollDirectionAngle, value: scrollDirectionAngle)
    }

    /// Returns a vertical pager
    ///
    /// - Parameter swipeDirection: direction of the swipe. Defaults to `.topToBottom`
    func vertical(_ swipeDirection: VerticalSwipeDirection = .topToBottom) -> Self {
        let scrollDirectionAngle: Angle = swipeDirection == .topToBottom ? .zero : Angle(degrees: 180)
        return mutating(keyPath: \.isHorizontal, value: false)
            .mutating(keyPath: \.scrollDirectionAngle, value: scrollDirectionAngle)
    }

    /// Call this method to provide a shrink ratio that will apply to the items that are not focused.
    ///
    /// - Parameter ratio: shrink ratio applied to unfocsed items
    /// - Note: `ratio` must be lower than _1_ and greather than _0_, otherwise it defaults to the previous value
    func interactive(scale ratio: CGFloat) -> Self {
        guard ratio > 0, ratio < 1 else { return self }
        return mutating(keyPath: \.interactiveScale, value: ratio)
    }

    /// Call this method to provide an interactive opacity effect to neighboring pages. The further they are
    /// from the focused page, the more opacity will be applied
    ///
    /// - Parameter decrement: opacity step increment between each index
    ///
    /// For instance, if the focused index is _3_ and `stepPercentage` is `0.4`,
    /// then page _2_ and _4_ will have an opacity of `0.8`, pages _1_ and _5_ will have
    /// an opacity of `0.4` and so on.
    ///
    /// - Note: `increment` must be lower than _1_ and greather than _0_
    func interactive(opacity decrement: Double?) -> Self {
        mutating(keyPath: \.opacityIncrement, value: decrement)
    }

    /// Call this method to add a 3D rotation effect.
    ///
    /// - Parameter value: `true` if the pages should have a 3D rotation effect
    func interactive(rotation shouldRotate: Bool) -> Self {
        mutating(keyPath: \.shouldRotate, value: shouldRotate)
    }

    /// Provides an increment to the page index offset. Use this to modify the scroll offset
    ///
    /// - Parameter value: manual offset applied to `Pager`
    func pageOffset(_ value: Double) -> Self {
        mutating(keyPath: \.pageOffset, value: value)
    }

    /// Adds space between each page
    ///
    /// - Parameter value: spacing between elements
    func itemSpacing(_ value: CGFloat) -> Self {
        mutating(keyPath: \.itemSpacing, value: value)
    }

    /// Configures the aspect ratio of each page. This value is considered to be _width / height_.
    ///
    /// - Parameter value: aspect ratio to be applied to the page
    /// - Parameter alignment: page position inside `Pager` when there's available space
    ///
    ///
    /// # Important Notes #
    /// - `value > 1` will make the page spread horizontally and have a width larger than its height.
    /// - `value < 1` will give the page a larger height.
    /// - `nil` will reset to the _default_ value and the page will take up all the available space
    /// - By calling this modifier, you'll be invalidating the previous values of `preferredItemSize`
    ///
    /// - Note: `value` should be greater than 0
    ///
    func itemAspectRatio(_ value: CGFloat?, alignment: PositionAlignment = .center) -> Self {
        return mutating(keyPath: \.preferredItemSize, value: nil)
            .mutating(keyPath: \.itemAspectRatio, value: value)
            .mutating(keyPath: \.itemAlignment, value: alignment)
    }

    /// Sets the preferred size for the items.
    ///
    /// - Parameter value: size
    /// - Parameter alignment: page position inside `Pager` when there's available spacer
    ///
    /// - Note: This will invalidate previous values of `padding` and `itemAspectRatio`
    func preferredItemSize(_ value: CGSize, alignment: PositionAlignment = .center) -> Self {
        mutating(keyPath: \.sideInsets, value: 0)
            .mutating(keyPath: \.itemAspectRatio, value: nil)
            .mutating(keyPath: \.itemAlignment, value: alignment)
            .mutating(keyPath: \.preferredItemSize, value: value)
    }

    /// Adds a callback to react whenever the page will change
    ///
    /// - Parameter callback: block to be called when `page` will  change
    func onPageWillChange(_ callback: ((Int) -> Void)?) -> Self {
        mutating(keyPath: \.onPageWillChange, value: callback)
    }

    /// Adds a callback to react whenever the page is transitioning.
    /// The `callback` result will inform the cient whether the `PageTransition` was sucessful
    ///
    /// - Parameter callback: block to be called when the user ends dragging and a transition will occur
    func onPageWillTransition(_ callback: ((Result<PageTransition, PageTransitionError>) -> Void)?) -> Self {
        mutating(keyPath: \.onPageWillTransition, value: callback)
    }

    /// Adds a callback to react whenever the page changes
    ///
    /// - Parameter callback: block to be called when `page` changes
    func onPageChanged(_ callback: ((Int) -> Void)?) -> Self {
        mutating(keyPath: \.onPageChanged, value: callback)
    }
	
    /// Sets some padding on the non-scroll axis
    ///
    /// - Parameter lenght: padding
    func padding(_ length: CGFloat) -> Self {
        mutating(keyPath: \.sideInsets, value: length)
    }

}
