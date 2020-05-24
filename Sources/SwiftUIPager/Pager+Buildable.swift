//
//  Pager+ViewModifiers.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

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

    /// Sets `Pager` to loop the items in a never-ending scroll. To have a nice experience, ensure that `numberOfPages >= numberOfPagesDisplayed`
    public func loopPages(_ value: Bool = true) -> Self {
        mutating(keyPath: \.isInifinitePager, value: value)
    }

    /// Disables dragging on `Pager`
    public func disableDragging() -> Self {
        mutating(keyPath: \.allowsDragging, value: false)
    }

    /// Sets whether the dragging is enabled or not
    public func allowsDragging(_ value: Bool = true) -> Self {
        mutating(keyPath: \.allowsDragging, value: value)
    }

    /// Sets the `DragGesture`'s minimumDistance to zero. Useful when embedded inside an interactive modal
    public func highPriorityGesture() -> Self {
        mutating(keyPath: \.minimumDistance, value: 0)
    }

    /// Indicates which area should allow hits and react to swipes
    public func swipeInteractionArea(_ value: SwipeInteractionArea) -> Self {
        mutating(keyPath: \.swipeInteractionArea, value: value)
    }

    /// Changes the a the  alignment of the pages relative to their container
    public func alignment(_ value: PositionAlignment) -> Self {
        mutating(keyPath: \.alignment, value: value)
    }

    /// Returns a horizontal pager
    public func horizontal(_ swipeDirection: HorizontalSwipeDirection = .leftToRight) -> Self {
        let scrollDirectionAngle: Angle = swipeDirection == .leftToRight ? .zero : Angle(degrees: 180)
        return mutating(keyPath: \.isHorizontal, value: true)
            .mutating(keyPath: \.scrollDirectionAngle, value: scrollDirectionAngle)
    }

    /// Returns a vertical pager
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
    public func pageOffset(_ pageOffset: Double) -> Self {
        mutating(keyPath: \.pageOffset, value: pageOffset)
    }

    /// Adds space between each page
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
    /// Note: `value` should be greater than 0
    public func itemAspectRatio(_ value: CGFloat?, alignment: PositionAlignment = .center) -> Self {
        guard (value ?? 1) > 0 else { return self }
        return mutating(keyPath: \.itemAspectRatio, value: value)
            .mutating(keyPath: \.itemAlignment, value: alignment)
    }
    
    /// Sets the `itemAspectRatio` to take up all the space available
    public func expandPageToEdges() -> Self {
        itemAspectRatio(nil)
    }

    /// Adds a callback to react to every change on the page index.
    public func onPageChanged(_ onPageChanged: ((Int) -> Void)?) -> Self {
        mutating(keyPath: \.onPageChanged, value: onPageChanged)
    }

    public func padding(_ length: CGFloat) -> Self {
        padding(.all, length)
    }
    
    public func padding(_ insets: EdgeInsets) -> Self {
        let length = isHorizontal ? min(insets.top, insets.bottom) : min(insets.leading, insets.trailing)
        let edges: Edge.Set = isHorizontal ? .vertical : .horizontal
        return padding(edges, length)
    }
    
    public func padding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> Self {
        let allowedEdges: Edge.Set = isHorizontal ? .vertical : .horizontal
        guard edges == .all || edges == allowedEdges else { return self }
        return mutating(keyPath: \.sideInsets, value: length ?? 8)
    }

}
