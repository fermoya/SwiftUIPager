//
//  PositionAlignment.swift
//  
//
//  Created by Fernando Moya de Rivas on 24/02/2020.
//

import CoreGraphics

/// `Alignment` determines the focused page alignment inside `Pager`
public enum PositionAlignment {
    /// Sets the alignment to be centered
    case center

    /// Sets the alignment to be at the start of the container with the specified insets:
    ///
    /// - Left, if horizontal
    /// - Top, if vertical
    case start(CGFloat)

    /// Sets the alignment to be at the start of the container with the specified insets:
    ///
    /// - Right, if horizontal
    /// - Bottom, if vertical
    case end(CGFloat)

    /// Returns the alignment insets
    var insets: CGFloat {
        switch self {
        case .center:
            return 0
        case .end(let insets), .start(let insets):
            return insets
        }
    }

    /// Helper to compare `Alignment` ignoring associated values
    func equalsIgnoreValues(_ alignment: PositionAlignment) -> Bool {
        switch (self, alignment) {
        case (.center, .center), (.start, .start), (.end, .end):
            return true
        default:
            return false
        }
    }

    /// Sets the alignment at the start, with 0 px of margin
    public static var start: PositionAlignment { .start(0) }

    /// Sets the alignment at the end, with 0 px of margin
    public static var end: PositionAlignment { .end(0) }
}
