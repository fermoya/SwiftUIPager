//
//  PaginationSensitivity_Tests.swift
//  
//
//  Created by Fernando Moya de Rivas on 12/10/2020.
//

import XCTest
@testable import SwiftUIPager

final class PaginationSensitivity_Tests: XCTestCase {

    func test_GivenSensitivityHigh_WhenValue_ThenAQuarter() {
        let sensitivity: PaginationSensitivity = .high
        let value = sensitivity.value
        XCTAssertEqual(value, 0.25)
    }

    func test_GivenSensitivityLow_WhenValue_ThenThreeQuarters() {
        let sensitivity: PaginationSensitivity = .low
        let value = sensitivity.value
        XCTAssertEqual(value, 0.75)
    }

    func test_GivenSensitivityDefault_WhenValue_ThenOneHalf() {
        let sensitivity: PaginationSensitivity = .default
        let value = sensitivity.value
        XCTAssertEqual(value, 0.5)
        XCTAssertEqual(sensitivity, .medium)
    }

    func test_GivenSensitivityCustom_WhenValue_ThenCustomValue() {
        let sensitivity: PaginationSensitivity = .custom(0.42)
        let value = sensitivity.value
        XCTAssertEqual(value, 0.42)
    }

    static var allTests = [
        ("test_GivenSensitivityHigh_WhenValue_ThenAQuarter", test_GivenSensitivityHigh_WhenValue_ThenAQuarter),
        ("test_GivenSensitivityLow_WhenValue_ThenThreeQuarters", test_GivenSensitivityLow_WhenValue_ThenThreeQuarters),
        ("test_GivenSensitivityDefault_WhenValue_ThenOneHalf", test_GivenSensitivityDefault_WhenValue_ThenOneHalf),
        ("test_GivenSensitivityCustom_WhenValue_ThenCustomValue", test_GivenSensitivityCustom_WhenValue_ThenCustomValue)
    ]

}
