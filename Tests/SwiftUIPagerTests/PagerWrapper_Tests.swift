//
//  File.swift
//  
//
//  Created by Fernando Moya de Rivas on 24/07/2020.
//

import XCTest
@testable import SwiftUIPager

final class PagerWrapper_Tests: XCTestCase {

    func test_GivenPageWrapper_WhenBatchId_ThenBatchIdAndElementId() {
        let wrapper = PageWrapper(batchId: 1, keyPath: \.self, element: 2)
        let id = wrapper.id
        XCTAssertEqual(id, "1-2")
    }

    static var allTests = [
        ("test_GivenPageWrapper_WhenBatchId_ThenBatchIdAndElementId", test_GivenPageWrapper_WhenBatchId_ThenBatchIdAndElementId)
    ]

}
