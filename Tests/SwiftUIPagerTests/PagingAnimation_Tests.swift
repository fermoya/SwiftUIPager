//
//  File.swift
//  
//
//  Created by Fernando Moya de Rivas on 05/08/2020.
//

import XCTest
import SwiftUI
@testable import SwiftUIPager

final class PagingAnimation_Tests: XCTestCase {

    func test_GivenPagingAnimationSteep_WhenAnimation_ThenExpectedAnimationValues() {
        let pagingAnimation: PagingAnimation = .steep
        let animation = pagingAnimation.animation
        XCTAssertEqual(animation, Animation.timingCurve(0.2, 1, 0.9, 1, duration: 0.2))
    }

    func test_GivenPagingAnimationStandard_WhenAnimation_ThenExpectedAnimationValues() {
        let pagingAnimation: PagingAnimation = .standard
        let animation = pagingAnimation.animation
        XCTAssertEqual(animation, Animation.easeOut(duration: 0.35))
    }

    func test_GivenPagingAnimationCustom_WhenAnimation_ThenExpectedAnimationValues() {
        let input = Animation.easeIn(duration: 1)
        let pagingAnimation: PagingAnimation = .custom(animation: input)
        let animation = pagingAnimation.animation
        XCTAssertEqual(animation, input)
    }

    static var allTests = [
        ("test_GivenPagingAnimationSteep_WhenAnimation_ThenExpectedAnimationValues", test_GivenPagingAnimationSteep_WhenAnimation_ThenExpectedAnimationValues),
        ("test_GivenPagingAnimationStandard_WhenAnimation_ThenExpectedAnimationValues", test_GivenPagingAnimationStandard_WhenAnimation_ThenExpectedAnimationValues),
        ("test_GivenPagingAnimationCustom_WhenAnimation_ThenExpectedAnimationValues", test_GivenPagingAnimationCustom_WhenAnimation_ThenExpectedAnimationValues)
    ]

}
