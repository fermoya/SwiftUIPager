//
//  Pager+ViewModifiers.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pager: Buildable {

    /// Swipe direction for a vertical `Pager`
    public enum HorizontalSwipeDirection {

        /// Pages move from left to right
        case leftToRight

        /// Pages move from right to left
        case rightToLeft
    }

    /// Swipe direction for a horizontal `Pager`
    public enum VerticalSwipeDirection {

        /// Pages move from top left to bottom
        case topToBottom

        /// Pages move from bottom to top
        case bottomToTop
    }

    /// Defines the area in `Pager` that allows hits and listens to swipes
    public enum SwipeInteractionArea {

        /// All available space inside `Pager`
        case allAvailable

        /// Just the page frame
        case page
    }

    /// Sets `Pager` to loop the items in a never-ending scroll.
    ///
    /// - Parameter value: `true` if `Pager` should loop the pages. `false`, otherwise.
    ///
    /// To have a nice experience, ensure that  the `data` passed in the intializer has enough elements to fill enough
    /// pages on both the screen and the sides.
    /// - Note: You can try experimenting with the `itemAspectRatio` or the `itemSpacing`.
    public func loopPages(_ value: Bool = true) -> Self {
        mutating(keyPath: \.isInifinitePager, value: value)
    }

    /// Disables dragging on `Pager`
    #if !os(tvOS)
    public func disableDragging() -> Self {
        mutating(keyPath: \.allowsDragging, value: false)
    }

    /// Sets whether the dragging is enabled or not
    ///
    /// - Parameter value: `true` if  dragging is allowed, `false`, otherwise. Defaults to `true`
    public func allowsDragging(_ value: Bool = true) -> Self {
        mutating(keyPath: \.allowsDragging, value: value)
    }

    /// Sets the `DragGesture`'s minimumDistance to zero. Useful when embedded inside an interactive modal
    public func highPriorityGesture() -> Self {
        mutating(keyPath: \.minimumDistance, value: 0)
    }

    /// Indicates which area should allow hits and react to swipes
    ///
    /// - Parameter value: area of interaction
    public func swipeInteractionArea(_ value: SwipeInteractionArea) -> Self {
        mutating(keyPath: \.swipeInteractionArea, value: value)
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
        let scrollDirectionAngle: Angle = swipeDirection == .leftToRight ? .zero : Angle(degrees: 180)
        return mutating(keyPath: \.isHorizontal, value: true)
            .mutating(keyPath: \.scrollDirectionAngle, value: scrollDirectionAngle)
    }

    /// Returns a vertical pager
    ///
    /// - Parameter swipeDirection: direction of the swipe. Defaults to `.topToBottom`
    public func vertical(_ swipeDirection: VerticalSwipeDirection = .topToBottom) -> Self {
        let scrollDirectionAngle: Angle = swipeDirection == .topToBottom ? .zero : Angle(degrees: 180)
        return mutating(keyPath: \.isHorizontal, value: false)
            .mutating(keyPath: \.scrollDirectionAngle, value: scrollDirectionAngle)
    }

    /// Call this method to provide a shrink ratio that will apply to the items that are not focused.
    ///
    /// - Parameter scale: shrink ratio
    /// - Note: `scale` must be lower than _1_ and greather than _0_, otherwise it defaults to the previous value
    public func interactive(_ scale: CGFloat) -> Self {
        guard !shouldRotate else { return self }
        guard scale > 0, scale < 1 else { return self }
        return mutating(keyPath: \.interactiveScale, value: scale)
    }
    
    /// Call this method to add a 3D rotation effect.
    ///
    /// - Parameter value: `true` if the pages should have a 3D rotation effect
    /// - Note: If you call this method, any previous or later call to `interactive` will have no effect.
    public func rotation3D(_ value: Bool = true) -> Self {
        mutating(keyPath: \.interactiveScale, value: value ? rotationInteractiveScale : 1)
            .mutating(keyPath: \.shouldRotate, value: value)
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

    /// Adds a callback to react to every change on the page index.
    ///
    /// - Parameter callback: block to be called when `page` changes
    public func onPageChanged(_ callback: ((Int) -> Void)?) -> Self {
        mutating(keyPath: \.onPageChanged, value: callback)
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
