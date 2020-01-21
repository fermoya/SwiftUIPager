//
//  Pager+ViewModifiers.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

extension Pager: Buildable {

    /// Call this method to provide a shrink ratio that will apply to the items that are not focused.
    ///
    /// - Parameter scale:      shrink ratio
    /// - Note:                 `scale` must be lower than _1_, otherwise it defaults to _1_
    public func interactive(_ scale: CGFloat) -> Self {
        let scale = min(1, abs(scale))
        return mutating(keyPath: \.interactiveScale, value: scale)
    }

    /// Provides an offset to modify the
    public func contentOffset(_ pageOffset: Double) -> Self {
        let contentOffset = CGFloat(pageOffset) * pageDistance
        return mutating(keyPath: \.contentOffset, value: contentOffset)
    }

    /// Adds space between each page
    public func itemSpacing(_ value: CGFloat) -> Self {
        mutating(keyPath: \.itemSpacing, value: value)
    }

    /// Configures the aspect ratio of each page. This value is considered to be _width / height_.
    ///
    /// - `value > 1` will make the page spread horizontally and have a width larger than its height.
    /// - `value < 0` will give the page a larger height.
    public func itemAspectRatio(_ value: CGFloat) -> Self {
        mutating(keyPath: \.itemAspectRatio, value: value)
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
        return padding(.vertical, length)
    }
    
    public func padding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> Self {
        guard edges == .all || edges == .vertical else { return self }
        return mutating(keyPath: \.verticalInsets, value: length ?? 8)
    }

}
