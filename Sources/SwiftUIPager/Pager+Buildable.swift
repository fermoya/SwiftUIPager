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

    /// Changes the a the  alignment of the pages relative to their container
    public func alignment(_ value: Alignment) -> Self {
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
    /// - Note: `scale` must be lower than _1_, otherwise it defaults to _1_
    public func interactive(_ scale: CGFloat) -> Self {
        guard !shouldRotate else { return self }
        let scale = min(1, abs(scale))
        return mutating(keyPath: \.interactiveScale, value: scale)
    }
    
    /// Call this method to add a 3D rotation effect.
    ///
    /// - Parameter value: `true` if the pages should have a 3D rotation effect
    /// - Note: If you call this method, any previous or later call to `interactive` will have no effect.
    public func rotation3D(_ value: Bool = true) -> Self {
        mutating(keyPath: \.interactiveScale, value: rotationInteractiveScale)
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
    /// - `value > 1` will make the page spread horizontally and have a width larger than its height.
    /// - `value < 1` will give the page a larger height.
    ///
    /// Note: `value` should be greater than 0
    public func itemAspectRatio(_ value: CGFloat?) -> Self {
        guard (value ?? 0) > 0 else { return self }
        return mutating(keyPath: \.itemAspectRatio, value: value)
    }

    /// Adds a callback to react to every change on the page index.
    public func onPageChanged(_ onPageChanged: ((Int) -> Void)?) -> Self {
        mutating(keyPath: \.onPageChanged, value: onPageChanged)
    }

    public func padding(_ length: CGFloat) -> Self {
        padding(.all, length)
    }
    
    public func padding(_ insets: EdgeInsets) -> Self {
        let length = min(insets.top, insets.bottom)
        let edges: Edge.Set = isHorizontal ? .vertical : .horizontal
        return padding(edges, length)
    }
    
    public func padding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> Self {
        let allowedEdges: Edge.Set = isHorizontal ? .vertical : .horizontal
        guard edges == .all || edges == allowedEdges else { return self }
        return mutating(keyPath: \.sideInsets, value: length ?? 8)
    }

}
