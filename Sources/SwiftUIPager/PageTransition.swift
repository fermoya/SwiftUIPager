//
//  PageTransition.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 3/6/21.
//  Copyright © 2021 Fernando Moya de Rivas. All rights reserved.
//

import Foundation

/// Holds information regarding the previous and new page
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct PageTransition {

    /// Current page
    public let currentPage: Int

    /// New page to transition to
    public let nextPage: Int

    /// Page Increment in absolute terms
    public let pageIncrement: Int
}

/// Errors that occur over a `PageTransition`
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum PageTransitionError: Error {

    /// Indicates that the transition couldn't success as the translation wasn't enough to move to the next page
    case draggingStopped
}
