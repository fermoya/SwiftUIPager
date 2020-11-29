//
//  SwipeDirection.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 01/07/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

/// Swipe direction for a vertical `Pager`
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum HorizontalSwipeDirection {

    /// Pages move from left to right
    case leftToRight

    /// Pages move from right to left
    case rightToLeft
}

/// Swipe direction for a horizontal `Pager`
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum VerticalSwipeDirection {

    /// Pages move from top left to bottom
    case topToBottom

    /// Pages move from bottom to top
    case bottomToTop
}
