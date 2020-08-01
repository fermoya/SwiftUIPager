//
//  CGPoint+Angle_Tests.swift
//  
//
//  Created by Fernando Moya de Rivas on 31/07/2020.
//

import XCTest
import SwiftUI
@testable import SwiftUIPager

final class CGPoint_Angle_Tests: XCTestCase {

    func test_GivenPoint_WhenAngle_Then45() throws {
        let point = CGPoint(x: 1, y: 1)
        let angle = try XCTUnwrap(point.angle)
        XCTAssertEqual(angle.degrees.rounded(), 45)
    }

    func test_GivenPoint_WhenAngle_Then135() throws {
        let point = CGPoint(x: -1, y: 1)
        let angle = try XCTUnwrap(point.angle)
        XCTAssertEqual(angle.degrees.rounded(), 135)
    }

    func test_GivenPoint_WhenAngle_Then225() throws {
        let point = CGPoint(x: -1, y: -1)
        let angle = try XCTUnwrap(point.angle)
        XCTAssertEqual(angle.degrees.rounded(), 225)
    }

    func test_GivenPoint_WhenAngle_Then315() throws {
        let point = CGPoint(x: 1, y: -1)
        let angle = try XCTUnwrap(point.angle)
        XCTAssertEqual(angle.degrees.rounded(), 315)
    }

    func test_GivenPoint_WhenAngle_Then30() throws {
        let point = CGPoint(x: sqrt(3), y: 1)
        let angle = try XCTUnwrap(point.angle)
        XCTAssertEqual(angle.degrees.rounded(), 30)
    }

    func test_GivenPoint_WhenAngle_Then150() throws {
        let point = CGPoint(x: -sqrt(3), y: 1)
        let angle = try XCTUnwrap(point.angle)
        XCTAssertEqual(angle.degrees.rounded(), 150)
    }

    func test_GivenPoint_WhenAngle_Then60() throws {
        let point = CGPoint(x: 1, y: sqrt(3))
        let angle = try XCTUnwrap(point.angle)
        XCTAssertEqual(angle.degrees.rounded(), 60)
    }

    func test_GivenPoint_WhenAngle_Then300() throws {
        let point = CGPoint(x: 1, y: -sqrt(3))
        let angle = try XCTUnwrap(point.angle)
        XCTAssertEqual(angle.degrees.rounded(), 300)
    }

    func test_GivenPoint_WhenAngle_Then0() throws {
        let point = CGPoint(x: 1, y: 0)
        let angle = try XCTUnwrap(point.angle)
        XCTAssertEqual(angle.degrees.rounded(), 0)
    }

    func test_GivenPoint_WhenAngle_Then180() throws {
        let point = CGPoint(x: -1, y: 0)
        let angle = try XCTUnwrap(point.angle)
        XCTAssertEqual(angle.degrees.rounded(), 180)
    }

    func test_GivenPoint_WhenAngle_Then90() throws {
        let point = CGPoint(x: 0, y: 1)
        let angle = try XCTUnwrap(point.angle)
        XCTAssertEqual(angle.degrees.rounded(), 90)
    }

    func test_GivenPoint_WhenAngle_Then270() throws {
        let point = CGPoint(x: 0, y: -1)
        let angle = try XCTUnwrap(point.angle)
        XCTAssertEqual(angle.degrees.rounded(), 270)
    }

    func test_GivenPoint_WhenAngle_ThenNil() {
        let point = CGPoint(x: 0, y: 0)
        XCTAssertNil(point.angle)
    }

    func test_GivenTwoPoints_WhenSubstract_ThenCoordinatesSubtracted() {
        let point1 = CGPoint(x: 5, y: 3)
        let point2 = CGPoint(x: 1, y: -2)
        let point3 = point1 - point2
        XCTAssertEqual(point3.x, 4)
        XCTAssertEqual(point3.y, 5)
    }

    func test_GivenAngles_WhenIsAlongXAxis_ThenTrue() {
        let degrees: [Double] = [26, 0, 180, 360, 720, 380, -380, -26, 163, 359, 330, 30, 150, 210, -30, 329.53, 30.35]
        let angles = degrees.map { Angle(degrees: $0) }
        angles.forEach {
            XCTAssertTrue($0.isAlongXAxis, "\($0.degrees) isn't along X Axis")
        }
    }

    func test_GivenAngles_WhenIsAlongXAxis_ThenFalse() {
        let degrees: [Double] = [40, 146, 327, -37, 270, -397, 90, 215, 329.12, 30.6, -30.6]
        let angles = degrees.map { Angle(degrees: $0) }
        angles.forEach {
            XCTAssertFalse($0.isAlongXAxis, "\($0.degrees) is along X Axis")
        }
    }

    static var allTests = [
        ("test_GivenPoint_WhenAngle_Then45", test_GivenPoint_WhenAngle_Then45),
        ("test_GivenPoint_WhenAngle_Then135", test_GivenPoint_WhenAngle_Then135),
        ("test_GivenPoint_WhenAngle_Then225", test_GivenPoint_WhenAngle_Then225),
        ("test_GivenPoint_WhenAngle_Then315", test_GivenPoint_WhenAngle_Then315),
        ("test_GivenPoint_WhenAngle_Then30", test_GivenPoint_WhenAngle_Then30),
        ("test_GivenPoint_WhenAngle_Then150", test_GivenPoint_WhenAngle_Then150),
        ("test_GivenPoint_WhenAngle_Then60", test_GivenPoint_WhenAngle_Then60),
        ("test_GivenPoint_WhenAngle_Then300", test_GivenPoint_WhenAngle_Then300),
        ("test_GivenPoint_WhenAngle_Then0", test_GivenPoint_WhenAngle_Then0),
        ("test_GivenPoint_WhenAngle_Then180", test_GivenPoint_WhenAngle_Then180),
        ("test_GivenPoint_WhenAngle_Then90", test_GivenPoint_WhenAngle_Then90),
        ("test_GivenPoint_WhenAngle_Then270", test_GivenPoint_WhenAngle_Then270),
        ("test_GivenPoint_WhenAngle_ThenNil", test_GivenPoint_WhenAngle_ThenNil),
        ("test_GivenTwoPoints_WhenSubstract_ThenCoordinatesSubtracted", test_GivenTwoPoints_WhenSubstract_ThenCoordinatesSubtracted),
        ("test_GivenAngles_WhenIsAlongXAxis_ThenTrue", test_GivenAngles_WhenIsAlongXAxis_ThenTrue),
        ("test_GivenAngles_WhenIsAlongXAxis_ThenFalse", test_GivenAngles_WhenIsAlongXAxis_ThenFalse)
    ]

}
