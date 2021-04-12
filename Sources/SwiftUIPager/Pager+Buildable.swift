//
//  Pager+Buildable.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 23/07/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pager: Buildable {

    /// Result of paginating
    public typealias DragResult = (page: Int, newPage: Int, translation: CGFloat, velocity: Double)

    /// Sets the animation to be applied when the user stops dragging
    ///
    /// - Parameter value: callback to get an animation based on the result of dragging
    @available(*, deprecated, message: "This method will no longer be mantained in future versions. Please use `draggingAnimation(_:)` instead")
    public func pagingAnimation(_ value: ((DragResult) -> PagingAnimation)?) -> Self {
        mutating(keyPath: \.pagingAnimation, value: value)
    }

    /// Allows to page more than one page at a time.
    ///
    /// - Note: This will change `contentLoadingPolicy` to `.eager`. Modifying this value will result in an unpredictable UI.
    public func multiplePagination() -> Self {
        mutating(keyPath: \.allowsMultiplePagination, value: true)
            .mutating(keyPath: \.contentLoadingPolicy, value: .eager)
    }

    /// Allows to scroll one page at a time. Use `ratio` to limit next item's reveal ratio.
    /// Once reached, items won't keep scrolling further.
    /// `Pager` will use then `sensitivity` to determine whether to paginate to the next page.
    ///
    /// - Parameter ratio: max page reveal ratio. Should be `0 < ratio < 1`. `default` is `1`
    /// - Parameter sensitivity: sensitivity to be applied when paginating. `default` is `medium` a.k.a `0.5`
    ///
    /// For instance, setting `ratio` to `0.33` will make `Pager` reveal up to a third of the next item.
    /// A proper  `sensitivy` for this scenario would be `high` (a.k.a, `0.33`) or a custom value lower than `ratio`
    public func singlePagination(ratio: CGFloat = 1, sensitivity: PaginationSensitivity = .medium) -> Self {
        mutating(keyPath: \.pageRatio, value: min(1, max(0, ratio)))
            .mutating(keyPath: \.allowsMultiplePagination, value: false)
            .mutating(keyPath: \.sensitivity, value: sensitivity)
    }

    /// Sets the policy followed to load `Pager` content.
    ///
    /// - Parameter value: policy to load the content.
    ///
    /// Choose `lazy` to load pages on demand so that the right amount of memory is used. Choose `eager` if
    /// `Pager` won't hold many items or if memory isn't  an issue.
    public func contentLoadingPolicy(_ value: ContentLoadingPolicy) -> Self {
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
    public func loopPages(_ value: Bool = true, repeating count: UInt = 1) -> Self {
        mutating(keyPath: \.isInifinitePager, value: value)
            .mutating(keyPath: \.loopingCount, value: count)
    }

    #if !os(tvOS)

    /// Sets the explicit animation to be used. Defaults to `.standard`
    ///
    /// - Parameter value: animation to use while dragging and to page
    ///
    /// - Warning: `spring` animations don't work well. Avoid high responses while dragging as the animation should be short
    public func draggingAnimation(_ value: DraggingAnimation) -> Self {
        mutating(keyPath: \.draggingAnimation, value: value)
    }

    /// Sets the explicit animation to be used. Defaults to `.standard`
    ///
    /// - Parameter anim1: animation to use while dragging
    /// - Parameter anim2: animation to use to page
    ///
    /// - Note: Setting different animations could cause unexpected behavior
    /// - Warning: `spring` animations don't work well. Avoid high responses while dragging as the animation should be short
    public func draggingAnimation(onChange anim1: DraggingAnimation, onEnded anim2: DraggingAnimation) -> Self {
        mutating(keyPath: \.draggingAnimation, value: anim1)
            .mutating(keyPath: \.pagingAnimation, value: { _ in anim2 })
    }

    /// Sensitivity used to determine whether or not to swipe the page
    ///
    /// - Parameter value: sensitivity to be applied when paginating
    public func sensitivity(_ value: PaginationSensitivity) -> Self {
        mutating(keyPath: \.sensitivity, value: value)
    }

    /// Makes `Pager` not delay gesture recognition
    ///
    /// - Parameter value: whether or not touches should be delayed
    public func delaysTouches(_ value: Bool) -> Self {
        mutating(keyPath: \.delaysTouches, value: value)
    }

    /// Disables dragging on `Pager`
    public func disableDragging() -> Self {
        mutating(keyPath: \.allowsDragging, value: false)
    }

    /// Sets whether the dragging is enabled or not
    ///
    /// - Parameter value: `true` if  dragging is allowed, `false`, otherwise. Defaults to `true`
    public func allowsDragging(_ value: Bool = true) -> Self {
        mutating(keyPath: \.allowsDragging, value: value)
    }

    /// Sets the priority used for paging the items
    ///
    /// - Parameter value: priority to receive touches
    ///
    /// By default, touches in a page may be blocked if the they occur on top a `View` with a `Gesture`.
    /// For instance, a `NavigationLink` or a `MagnificationGesture` inside a page can "break" the swiping in `Pager`.
    /// To solve this issue, use `pagingPriority(.simultaneous)` to let the touch be received for both the page content and `Pager`.
    public func pagingPriority(_ value: GesturePriority) -> Self {
        mutating(keyPath: \.gesturePriority, value: value)
    }

    /// Indicates which area should allow hits and react to swipes
    ///
    /// - Parameter value: area of interaction
    public func swipeInteractionArea(_ value: SwipeInteractionArea) -> Self {
        mutating(keyPath: \.swipeInteractionArea, value: value)
    }

    /// Sets whether `Pager` should bounce or not
    public func bounces(_ value: Bool) -> Self {
        mutating(keyPath: \.bounces, value: value)
    }

    /// Adds a callback to react when dragging begins
    ///
    /// - Parameter callback: block to be called when  dragging begins
    public func onDraggingBegan(_ callback: (() -> Void)?) -> Self {
        mutating(keyPath: \.onDraggingBegan, value: callback)
    }

    /// Adds a callback to react when dragging changes
    ///
    /// - Parameter callback: block to be called when  dragging changes. `pageInrement` is passed as argument
    public func onDraggingChanged(_ callback: ((Double) -> Void)?) -> Self {
        mutating(keyPath: \.onDraggingChanged, value: callback)
    }

    /// Adds a callback to react when dragging ends
    ///
    /// - Parameter callback: block to be called when  dragging ends.
    public func onDraggingEnded(_ callback: (() -> Void)?) -> Self {
        mutating(keyPath: \.onDraggingEnded, value: callback)
    }

    #endif

    /// Changes the a the  alignment of the pages relative to their container
    ///
    /// - Parameter value: alignment of the pages inside the scroll
    public func alignment(_ value: PositionAlignment) -> Self {
        mutating(keyPath: \.alignment, value: value)
    }

    /// Returns a horizontal pager
    ///
    /// - Parameter swipeDirection: direction of the swipe. Defaults to `.leftToRight`
    public func horizontal(_ swipeDirection: HorizontalSwipeDirection = .leftToRight) -> Self {
        mutating(keyPath: \.isHorizontal, value: true)
            .mutating(keyPath: \.horizontalSwipeDirection, value: swipeDirection)
    }

    /// Returns a vertical pager
    ///
    /// - Parameter swipeDirection: direction of the swipe. Defaults to `.topToBottom`
    public func vertical(_ swipeDirection: VerticalSwipeDirection = .topToBottom) -> Self {
        mutating(keyPath: \.isHorizontal, value: false)
            .mutating(keyPath: \.verticalSwipeDirection, value: swipeDirection)
    }

    /// Call this method to provide a shrink ratio that will apply to the items that are not focused.
    ///
    /// - Parameter scale: shrink ratio
    /// - Note: `scale` must be lower than _1_ and greather than _0_, otherwise it defaults to the previous value
    @available(*, deprecated, renamed: "interactive(scale:)")
    public func interactive(_ scale: CGFloat) -> Self {
        guard !shouldRotate else { return self }
        return interactive(scale: scale)
    }

    /// Call this method to provide a shrink ratio that will apply to the items that are not focused.
    ///
    /// - Parameter ratio: shrink ratio applied to unfocsed items
    /// - Note: `ratio` must be lower than _1_ and greather than _0_, otherwise it defaults to the previous value
    public func interactive(scale ratio: CGFloat) -> Self {
        return mutating(keyPath: \.interactiveScale, value: max(0, min(1, ratio)))
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
    public func interactive(opacity decrement: Double) -> Self {
        mutating(keyPath: \.opacityIncrement, value: decrement)
    }

    /// Call this method to add a 3D rotation effect.
    ///
    /// - Parameter value: `true` if the pages should have a 3D rotation effect
    public func interactive(rotation shouldRotate: Bool) -> Self {
        mutating(keyPath: \.shouldRotate, value: shouldRotate)
    }

    /// Call this method to add a 3D rotation effect.
    ///
    /// - Parameter value: `true` if the pages should have a 3D rotation effect
    /// - Note: If you call this method, any previous or later call to `interactive` will have no effect.
    @available(*, deprecated, renamed: "interactive(rotation:)")
    public func rotation3D(_ value: Bool = true) -> Self {
        interactive(scale: value ? 0.7 : 1)
            .interactive(rotation: value)
    }

    /// Provides an increment to the page index offset. Use this to modify the scroll offset
    ///
    /// - Parameter value: manual offset applied to `Pager`
    public func pageOffset(_ value: Double) -> Self {
        mutating(keyPath: \.pageOffset, value: value)
    }

    /// Adds space between each page
    ///
    /// - Parameter value: spacing between elements
    public func itemSpacing(_ value: CGFloat) -> Self {
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
    public func itemAspectRatio(_ value: CGFloat?, alignment: PositionAlignment = .center) -> Self {
        guard (value ?? 1) > 0 else { return self }
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
    public func preferredItemSize(_ value: CGSize, alignment: PositionAlignment = .center) -> Self {
        mutating(keyPath: \.sideInsets, value: 0)
            .mutating(keyPath: \.itemAspectRatio, value: nil)
            .mutating(keyPath: \.itemAlignment, value: alignment)
            .mutating(keyPath: \.preferredItemSize, value: value)
    }

    /// Sets the `itemAspectRatio` to take up all the space available
    public func expandPageToEdges() -> Self {
        itemAspectRatio(nil)
    }

    /// Adds a callback to react whenever the page changes
    ///
    /// - Parameter callback: block to be called when `page` changes
    public func onPageChanged(_ callback: ((Int) -> Void)?) -> Self {
        mutating(keyPath: \.onPageChanged, value: callback)
    }

    /// Adds a callback to react whenever the page will change
    ///
    /// - Parameter callback: block to be called when `page` will  change
    public func onPageWillChange(_ callback: ((Int) -> Void)?) -> Self {
        mutating(keyPath: \.onPageWillChange, value: callback)
    }

    /// Sets some padding on the non-scroll axis
    ///
    /// - Parameter lenght: padding
    public func padding(_ length: CGFloat) -> Self {
        padding(.all, length)
    }

    /// Sets some padding on the non-scroll axis. It will take the minimum value passed for the vertical insets on an horizontal `Pager`,
    /// and the horizontal insets in case `Pager` is vertical
    ///
    /// - Parameter insets: insets to add as padding
    public func padding(_ insets: EdgeInsets) -> Self {
        let length = isHorizontal ? min(insets.top, insets.bottom) : min(insets.leading, insets.trailing)
        let edges: Edge.Set = isHorizontal ? .vertical : .horizontal
        return padding(edges, length)
    }

    /// Sets some padding on the non-scroll axis. Will be set in case edges is `.all`, `.vertical` for a horizontal `Pager`
    /// or `.horizontal` for a horizontal `Pager`.
    ///
    /// - Parameter edges: edges the padding should be applied along. Defaults to `.all`
    /// - Parameter lenght: padding to be applied. Default to `8`.
    public func padding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> Self {
        guard preferredItemSize == nil else { return self }
        let allowedEdges: Edge.Set = isHorizontal ? .vertical : .horizontal
        guard edges == .all || edges == allowedEdges else { return self }
        return mutating(keyPath: \.sideInsets, value: length ?? 8)
    }

}

