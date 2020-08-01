//
//  PagingAnimation.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 01/08/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

/// Animation to be used when the user stops dragging
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public enum PagingAnimation: Equatable {

    /// Highly steep curve. Very fast on start, slow on end.
    ///
    /// - Parameter duration: duration of the animation
    ///
    /// See the bezier curve [here](https://cubic-bezier.com/#.2,1,.9,1).
    case steep(duration: TimeInterval)

    /// Standard animation, ease-out.
    ///
    /// - Parameter duration: duration of the animation
    case standard(duration: TimeInterval)

    /// Pass your custom animation
    ///
    /// - Parameter animation: animation to be applied
    case custom(animation: Animation)

    /// Standard animation. Single pagination `Pager` defaults to this value. Ease-out, 0.35 seconds.
    public static var standard: PagingAnimation = .standard(duration: 0.35)

    /// Highly steep curve. Very fast on start, slow on end. Multiple pagination `Pager` defaults to this value.
    /// See the bezier curve [here](https://cubic-bezier.com/#.2,1,.9,1).
    public static var steep: PagingAnimation = .steep(duration: 0.2)

    /// Translates the option selected to a `SwiftUI` animation
    var animation: Animation {
        switch self {
        case .steep(let duration):
            return Animation.timingCurve(0.2, 1, 0.9, 1, duration: duration)
        case .standard(let duration):
            return Animation.easeOut(duration: duration)
        case .custom(let animation):
            return animation
        }
    }
}
