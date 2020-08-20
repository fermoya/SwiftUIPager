//
//  PagerProxy.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 23/07/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
protocol PagerProxy {
    /*** ViewModified properties ***/

    /// Hittable area
    var swipeInteractionArea: SwipeInteractionArea { get }

    /// Item alignment inside `Pager`
    var itemAlignment: PositionAlignment { get }

    /// The elements alignment relative to the container
    var alignment: PositionAlignment { get }

    /// `true` if the pager is horizontal
    var isHorizontal: Bool { get }

    /// Shrink ratio that affects the items that aren't focused
    var interactiveScale: CGFloat { get }

    /// `true` if  `Pager` can be dragged
    var allowsDragging: Bool { get }

    /// `true` if pages should have a 3D rotation effect
    var shouldRotate: Bool { get }

    /// Used to modify `Pager` offset outside this view
    var pageOffset: Double { get }

    /// Vertical padding
    var sideInsets: CGFloat { get }

    /// Space between pages
    var itemSpacing: CGFloat { get }

    /// Whether the `Pager` loops endlessly
    var isInifinitePager: Bool { get }

    /// Whether the `Pager` should page multiple pages at once
    var allowsMultiplePagination: Bool { get }

    /// Priority selected to add `swipeGesture`
    var gesturePriority: GesturePriority { get }

    /// Will apply this ratio to each page item. The aspect ratio follows the formula _width / height_
    var itemAspectRatio: CGFloat?  { get }

    /// Will try to have the items fit this size
    var preferredItemSize: CGSize?  { get }

    /// Callback for every new page
    var onPageChanged: ((Int) -> Void)?  { get }
	
	/// Callback for when dragging begins
	var onDraggingBegan: (() -> Void)? { get }

    /// Allows to page more than one page at a time.
    ///
    /// - Note: This will change `contentLoadingPolicy` to `.eager`. Modifying this value will result in an unpredictable UI.
    func multiplePagination() -> Self

    /// Sets the policy followed to load `Pager` content.
    ///
    /// - Parameter value: policy to load the content.
    ///
    /// Choose `lazy` to load pages on demand so that the right amount of memory is used. Choose `eager` if
    /// `Pager` won't hold many items or if memory isn't  an issue.
    func contentLoadingPolicy(_ value: ContentLoadingPolicy) -> Self

    /// Sets `Pager` to loop the items in a never-ending scroll.
    ///
    /// - Parameter value: `true` if `Pager` should loop the pages. `false`, otherwise.
    /// - Parameter count: number of times the input data should be repeated in a looping `Pager`. Default is _1_.
    ///
    /// To have a nice experience, ensure that  the `data` passed in the intializer has enough elements to fill
    /// pages on both the screen and the sides. If your sequence is not large enough, use `count` to
    /// repeat it and pass more elements.
    func loopPages(_ value: Bool, repeating count: UInt) -> Self

    #if !os(tvOS)

    /// Makes `Pager` not delay gesture recognition
    ///
    /// - Parameter value: whether or not touches should be delayed
    func delaysTouches(_ value: Bool) -> Self

    /// Sets whether the dragging is enabled or not
    ///
    /// - Parameter value: `true` if  dragging is allowed, `false`, otherwise. Defaults to `true`
    func allowsDragging(_ value: Bool) -> Self

    /// Sets the priority used for paging the items
    ///
    /// - Parameter value: priority to receive touches
    ///
    /// By default, touches in a page may be blocked if the they occur on top a `View` with a `Gesture`.
    /// For instance, a `NavigationLink` or a `MagnificationGesture` inside a page can "break" the swiping in `Pager`.
    /// To solve this issue, use `pagingPriority(.simultaneous)` to let the touch be received for both the page content and `Pager`.
    func pagingPriority(_ value: GesturePriority) -> Self

    /// Indicates which area should allow hits and react to swipes
    ///
    /// - Parameter value: area of interaction
    func swipeInteractionArea(_ value: SwipeInteractionArea) -> Self

    #endif

    /// Changes the a the  alignment of the pages relative to their container
    ///
    /// - Parameter value: alignment of the pages inside the scroll
    func alignment(_ value: PositionAlignment) -> Self

    /// Returns a horizontal pager
    ///
    /// - Parameter swipeDirection: direction of the swipe. Defaults to `.leftToRight`
    func horizontal(_ swipeDirection: HorizontalSwipeDirection) -> Self

    /// Returns a vertical pager
    ///
    /// - Parameter swipeDirection: direction of the swipe. Defaults to `.topToBottom`
    func vertical(_ swipeDirection: VerticalSwipeDirection) -> Self

    /// Call this method to provide a shrink ratio that will apply to the items that are not focused.
    ///
    /// - Parameter scale: shrink ratio
    /// - Note: `scale` must be lower than _1_ and greather than _0_, otherwise it defaults to the previous value
    func interactive(_ scale: CGFloat) -> Self

    /// Call this method to add a 3D rotation effect.
    ///
    /// - Parameter value: `true` if the pages should have a 3D rotation effect
    /// - Note: If you call this method, any previous or later call to `interactive` will have no effect.
    func rotation3D(_ value: Bool) -> Self

    /// Provides an increment to the page index offset. Use this to modify the scroll offset
    ///
    /// - Parameter value: manual offset applied to `Pager`
    func pageOffset(_ value: Double) -> Self

    /// Adds space between each page
    ///
    /// - Parameter value: spacing between elements
    func itemSpacing(_ value: CGFloat) -> Self

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
    func itemAspectRatio(_ value: CGFloat?, alignment: PositionAlignment) -> Self

    /// Sets the preferred size for the items.
    ///
    /// - Parameter value: size
    /// - Parameter alignment: page position inside `Pager` when there's available spacer
    ///
    /// - Note: This will invalidate previous values of `padding` and `itemAspectRatio`
    func preferredItemSize(_ value: CGSize, alignment: PositionAlignment) -> Self

    /// Adds a callback to react to every change on the page index.
    ///
    /// - Parameter callback: block to be called when `page` changes
    func onPageChanged(_ callback: ((Int) -> Void)?) -> Self
	
	/// Adds a callback to react when dragging begins. Useful for dismissing a keyboard like a scrollview
	///
	/// - Parameter callback: block to be called when  dragging begins
	func onDraggingBegan(_ callback: (() -> Void)?) -> Self

    /// Sets some padding on the non-scroll axis
    ///
    /// - Parameter lenght: padding
    func padding(_ length: CGFloat) -> Self

}
