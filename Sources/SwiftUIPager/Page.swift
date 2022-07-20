//
//  Pager.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI
import Combine

/// Encapsulates `Pager` state.
///
/// Initialize with one of its convenience methods:
/// - `firstPage()`
/// - `withIndex(_:)`
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public class Page: ObservableObject {

    // Needed for `iOS 13` or else it won't trigger an update
    public var objectWillChange = PassthroughSubject<Void, Never>()
    var _index: Int

    /// Current page index.
    /// - Note: Modifying its value won't trigger a `SwiftUI` update, use `update(_:)` method instead.
    public var index: Int {
        get { _index }
        set {
          guard isInfinite else {
            return _index = min(totalPages - 1, max(0, newValue))
          }
          _index = (newValue + totalPages) % totalPages
        }
    }

    /// Total number of pages
    var totalPages: Int = Int.max {
        didSet {
            // reset in case there's a deletion
            self.index = totalPages > 0 ? index : 0
        }
    }
    
    #if !os(tvOS)
    
    /// `swipeGesture` translation on the X-Axis
    var draggingOffset: CGFloat = 0

    /// `swipeGesture` last translation on the X-Axis
    var lastDraggingValue: DragGesture.Value?
    
    /// `swipeGesture` velocity on the X-Axis
    var draggingVelocity: Double = 0
    
    #endif

    /// Increment resulting from the last swipe
    var pageIncrement = 0
  
    var isInfinite = false

    var lastDigitalCrownPageOffset: CGFloat = 0

    /// Initializes a new instance
    /// 
    /// - Parameter page: Current page index
    private init(page: Int) {
        self._index = page
    }

}

// MARK: Public

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Page {

    /// An update to perform on a `Page` index
    public enum Update {

        /// Will increase the `index` by `1`
        case next

        /// Will decrease the `index` by `1`
        case previous

        /// Will move to the first page
        case moveToFirst

        /// Will increment or decrement the `index` by the passed argument
        case move(increment: Int)

        /// Will move to the last page
        case moveToLast

        /// Will set the `index` to the new value
        case new(index: Int)
    }

    /// Convenience method to initialize a new `Page`
    ///
    /// - Parameter index: Current page index
    public static func withIndex(_ index: Int) -> Page {
        Page(page: index)
    }

    /// Convenience method to initialize a new `Page`
    ///
    /// - Parameter index: Current page index
    public static func first() -> Page {
        withIndex(0)
    }

    /// Will update `Page` accordingly and trigger `objectWillChange`
    ///
    /// - Parameter update: update to perform
    ///
    /// If you do not wish to trigger an update because you want to take control of the update, set `index` direclty
    public func update(_ update: Update) {
        switch update {
        case .next:
            index += 1
        case .previous:
            index -= 1
        case .moveToFirst:
            index = 0
        case .moveToLast:
            index = totalPages - 1
        case .move(let increment):
            index += increment
        case .new(let newIndex):
            index = newIndex
        }

        objectWillChange.send()
    }

}
