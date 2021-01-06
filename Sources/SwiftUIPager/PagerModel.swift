//
//  Pager+Helper.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

// More info [here](https://developer.apple.com/forums/thread/667988),
// [here](https://developer.apple.com/forums/thread/667720)
// and [here](https://stackoverflow.com/questions/65476905/binding-and-state-not-updating-at-the-same-time/65479009#65479009)
/// Encapsulates `Pager` state
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public class PagerModel: ObservableObject {

    /// Page index
    public var page: Int {
        didSet {
            objectWillChange.send()
            onPageChanged?(page)
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
    var pageIncrement = 1
    
    /// Callback for every new page
    var onPageChanged: ((Int) -> Void)?

    /// Initializes a new instance
    /// 
    /// - Parameter page: Current page index
    public init(page: Int) {
        self.page = page
    }

}
