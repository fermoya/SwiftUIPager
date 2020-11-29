//
//  CGPoint+Angle.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 23/07/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension CGPoint {

    var angle: Angle? {
        guard x != 0 || y != 0 else { return nil }
        guard x != 0 else { return y > 0 ? Angle(degrees: 90) : Angle(degrees: 270) }
        guard y != 0 else { return x > 0 ? Angle(degrees: 0) : Angle(degrees: 180) }
        var angle = atan(abs(y) / abs(x)) * 180 / .pi
        switch (x, y) {
        case (let x, let y) where x < 0 && y < 0:
            angle = 180 + angle
        case (let x, let y) where x < 0 && y > 0:
            angle = 180 - angle
        case (let x, let y) where x > 0 && y < 0:
            angle = 360 - angle
        default:
            break
        }

        return .init(degrees: Double(angle))
    }

    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Angle {
    var isAlongXAxis: Bool {
        let degrees = ((Int(self.degrees.rounded()) % 360) + 360) % 360
        return degrees >= 330 || degrees <= 30 || (degrees >= 150 && degrees <= 210)
    }
}
