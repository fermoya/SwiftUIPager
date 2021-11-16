//
//  PaginationSensitivity.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 12/10/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import CoreGraphics

/// Defines how sensitive the pagination is to determine whether or not to move to the next the page.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public enum PaginationSensitivity: Equatable {

    /// The shift relative to container size needs to be greater than or equal to 75%
    case low

    /// The shift relative to container size needs to be greater than or equal to 50%
    case medium

    /// The shift relative to container size needs to be greater than or equal to 25%
    case high

    /// The shift relative to container size needs to be greater than or equal to the specified value
    case custom(CGFloat)

    /// The shift relative to container size needs to be greater than or equal to 50%
    public static var `default`: Self = .medium

    var value: CGFloat {
        switch self {
        case .low:
            return 0.75
        case .high:
            return 0.25
        case .medium:
            return 0.5
        case .custom(let value):
            return value
        }
    }

}
