//
//  File.swift
//  
//
//  Created by Fernando Moya de Rivas on 14/1/21.
//

import XCTest
@testable import SwiftUIPager

final class Page_Tests: XCTestCase {

    func test_WhenFirst_ThenIndexZero()  {
        let page: Page = .first()
        XCTAssertEqual(page.index, 0)
    }

    func test_WhenWithIndex_ThenSelectedIndex()  {
        let page: Page = .withIndex(3)
        XCTAssertEqual(page.index, 3)
    }

    func test_GivenPage_WhenNegativeIndex_ThenZero()  {
        let page: Page = .first()
        page.totalPages = 10
        page.index = -4

        XCTAssertEqual(page.index, 0)
    }

    func test_GivenPage_WhenIndexTooBig_ThenLastIndex()  {
        let page: Page = .first()
        page.totalPages = 10
        page.index = 10

        XCTAssertEqual(page.index, 9)
    }

    func test_GivenPage_WhenUpdateNext_ThenNextIndex()  {
        let page: Page = .first()
        page.totalPages = 10
        page.update(.next)

        XCTAssertEqual(page.index, 1)
    }

    func test_GivenPage_WhenUpdatePrevious_ThenPreviousIndex()  {
        let page: Page = .withIndex(1)
        page.totalPages = 10
        page.update(.previous)

        XCTAssertEqual(page.index, 0)
    }

    func test_GivenPage_WhenUpdateMoveToFirst_ThenIndexZero()  {
        let page: Page = .withIndex(4)
        page.totalPages = 10
        page.update(.moveToFirst)

        XCTAssertEqual(page.index, 0)
    }

    func test_GivenPage_WhenUpdateMoveToLast_ThenLastIndex()  {
        let page: Page = .withIndex(4)
        page.totalPages = 10
        page.update(.moveToLast)

        XCTAssertEqual(page.index, 9)
    }

    func test_GivenPage_WhenUpdateNewIndex_ThenSelectedIndex()  {
        let page: Page = .withIndex(4)
        page.totalPages = 10
        page.update(.new(index: 1))

        XCTAssertEqual(page.index, 1)
    }

    static var allTests = [
        ("test_WhenFirst_ThenIndexZero", test_WhenFirst_ThenIndexZero),
        ("test_WhenWithIndex_ThenSelectedIndex", test_WhenWithIndex_ThenSelectedIndex),
        ("test_GivenPage_WhenNegativeIndex_ThenZero", test_GivenPage_WhenNegativeIndex_ThenZero),
        ("test_GivenPage_WhenIndexTooBig_ThenLastIndex", test_GivenPage_WhenIndexTooBig_ThenLastIndex),
        ("test_GivenPage_WhenUpdateNext_ThenNextIndex", test_GivenPage_WhenUpdateNext_ThenNextIndex),
        ("test_GivenPage_WhenUpdatePrevious_ThenPreviousIndex", test_GivenPage_WhenUpdatePrevious_ThenPreviousIndex),
        ("test_GivenPage_WhenUpdateMoveToFirst_ThenIndexZero", test_GivenPage_WhenUpdateMoveToFirst_ThenIndexZero),
        ("test_GivenPage_WhenUpdateMoveToLast_ThenLastIndex", test_GivenPage_WhenUpdateMoveToLast_ThenLastIndex),
        ("test_GivenPage_WhenUpdateNewIndex_ThenSelectedIndex", test_GivenPage_WhenUpdateNewIndex_ThenSelectedIndex)
    ]

}
