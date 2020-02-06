import XCTest
import SwiftUI
@testable import SwiftUIPager

final class SwiftUIPagerTests: XCTestCase {

    var givenPager: Pager<Int, Int, Text> {
        Pager(page: .constant(0), data: Array(1..<20), id: \.self) {
            Text("\($0)")
        }
    }

    func test_GivenPager_ThenDefaultValues() {
        let pager = givenPager
        XCTAssertNil(pager.itemAspectRatio)
        XCTAssertTrue(pager.isHorizontal)
        XCTAssertEqual(pager.scrollDirectionAngle, .zero)
        XCTAssertEqual(pager.interactiveScale, 1)
        XCTAssertEqual(pager.alignment, .center)
        XCTAssertFalse(pager.shouldRotate)
        XCTAssertEqual(pager.pageOffset, 0)
        XCTAssertEqual(pager.sideInsets, 0)
        XCTAssertEqual(pager.itemSpacing, 0)
    }

    func test_GivenPager_WhenVertical_ThenIsVerticalTrue() {
        var pager = givenPager
        pager = pager.vertical()
        XCTAssertTrue(pager.isVertical)
        XCTAssertEqual(pager.scrollDirectionAngle, .zero)
    }

    func test_GivenPager_WhenAlignment_ThenAlignmentSet() {
        var pager = givenPager
        pager = pager.alignment(.end(10))
        XCTAssertEqual(pager.alignment, .end(10))
    }

    func test_GivenPager_WhenVerticalBottomToTop_ThenIsVerticalTrue() {
        var pager = givenPager
        pager = pager.vertical(.bottomToTop)
        XCTAssertTrue(pager.isVertical)
        XCTAssertEqual(pager.scrollDirectionAngle, Angle(degrees: 180))
    }

    static var allTests = [
        ("test_GivenPager_WhenVertical_ThenIsVerticalTrue", test_GivenPager_WhenVertical_ThenIsVerticalTrue),
    ]
}
