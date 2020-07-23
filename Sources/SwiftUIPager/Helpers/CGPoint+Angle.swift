//
//  CGPoint+Angle.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 23/07/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension CGPoint {

    var angle: Angle {
        var angle = atan(y / x) * 180 / .pi
        angle = (x < 0 && y < 0) ? angle + 180 : angle
        angle = angle < 0 ? (y < 0 ? 360 + angle : 180 + angle) : angle
        return .init(degrees: Double(angle))
    }

    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

}

extension Angle {
    var isAlongXAxis: Bool {
        degrees > 335 || degrees < 25 || (degrees > 155 && degrees < 205)
    }
}
