//
//  SwipeDirection.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 01/07/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import Foundation
import SwiftUI

/// Swipe direction for a vertical `Pager`
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum HorizontalSwipeDirection {

    /// Pages move from left to right
    @available(*, deprecated, message: "Use `startToEnd` instead")
    static var leftToRight: Self { .startToEnd }

    /// Pages move from right to left
    @available(*, deprecated, message: "Use `endToStart` instead")
    static var rightToLeft: Self { .endToStart }

    /// Pages move forwards (i.e. left to right in English, right to left in Arabic)
    case startToEnd

    /// Pages move backwards (i.e. right to left in English, left to right in Arabic)
    case endToStart
}

/// Swipe direction for a horizontal `Pager`
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum VerticalSwipeDirection {

    /// Pages move from top left to bottom
    case topToBottom

    /// Pages move from bottom to top
    case bottomToTop
}

extension Locale {
    var isRightToLeft: Bool {
        guard let language = self.languageCode else { return false }
        let direction = Locale.characterDirection(forLanguage: language)
        return direction == .rightToLeft
    }
}
