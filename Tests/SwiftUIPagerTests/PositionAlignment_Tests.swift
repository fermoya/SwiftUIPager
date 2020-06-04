import XCTest
import SwiftUI
@testable import SwiftUIPager

final class PositionAlignment_Tests: XCTestCase {

    func test_GivenStartAlignment_WhenEqualsIgnoreValues_ThenTrue() {
        let alignment: PositionAlignment = .start(20)
        XCTAssertTrue(alignment.equalsIgnoreValues(.start(10)))
    }

    func test_GivenCenterAlignment_WhenEqualsIgnoreValues_ThenTrue() {
        let alignment: PositionAlignment = .center
        XCTAssertTrue(alignment.equalsIgnoreValues(.center))
    }

    func test_GivenJustifiedAlignment_WhenEqualsIgnoreValues_ThenTrue() {
        let alignment: PositionAlignment = .justified(10)
        XCTAssertTrue(alignment.equalsIgnoreValues(.justified))
    }

    func test_GivenEndAlignment_WhenEqualsIgnoreValues_ThenTrue() {
        let alignment: PositionAlignment = .end(10)
        XCTAssertTrue(alignment.equalsIgnoreValues(.end))
    }

    func test_GivenAlignment_WhenStart_ThenInsetsZero() {
        let alignment: PositionAlignment = .start
        XCTAssertEqual(alignment.insets, 0)
    }

    func test_GivenAlignment_WhenEnd_ThenInsetsZero() {
        let alignment: PositionAlignment = .end
        XCTAssertEqual(alignment.insets, 0)
    }

    func test_GivenAlignment_WhenJustified_ThenInsetsZero() {
        let alignment: PositionAlignment = .justified
        XCTAssertEqual(alignment.insets, 0)
    }

    func test_GivenStartAlignment_WhenEqualsIgnoreValues_ThenFalse() {
        let alignment: PositionAlignment = .center
        XCTAssertFalse(alignment.equalsIgnoreValues(.start(10)))
    }

    func test_GivenCenterAlignment_WhenInsets_ThenZero() {
        let alignment: PositionAlignment = .center
        XCTAssertEqual(alignment.insets, 0)
    }

    func test_GivenEndAlignment_WhenInsets_ThenInsets() {
        let insets: CGFloat = 15
        let alignment: PositionAlignment = .end(insets)
        XCTAssertEqual(alignment.insets, insets)
    }

    func test_GivenStartAlignment_WhenInsets_ThenInsets() {
        let insets: CGFloat = 15
        let alignment: PositionAlignment = .start(insets)
        XCTAssertEqual(alignment.insets, insets)
    }

    func test_GivenJustifiedAlignment_WhenInsets_ThenInsets() {
        let insets: CGFloat = 15
        let alignment: PositionAlignment = .justified(insets)
        XCTAssertEqual(alignment.insets, insets)
    }

    static var allTests = [
        ("test_GivenStartAlignment_WhenEqualsIgnoreValues_ThenTrue", test_GivenStartAlignment_WhenEqualsIgnoreValues_ThenTrue),
        ("test_GivenCenterAlignment_WhenEqualsIgnoreValues_ThenTrue", test_GivenCenterAlignment_WhenEqualsIgnoreValues_ThenTrue),
        ("test_GivenJustifiedAlignment_WhenEqualsIgnoreValues_ThenTrue", test_GivenJustifiedAlignment_WhenEqualsIgnoreValues_ThenTrue),
        ("test_GivenEndAlignment_WhenEqualsIgnoreValues_ThenTrue", test_GivenEndAlignment_WhenEqualsIgnoreValues_ThenTrue),
        ("test_GivenAlignment_WhenStart_ThenInsetsZero", test_GivenAlignment_WhenStart_ThenInsetsZero),
        ("test_GivenAlignment_WhenEnd_ThenInsetsZero", test_GivenAlignment_WhenEnd_ThenInsetsZero),
        ("test_GivenAlignment_WhenJustified_ThenInsetsZero", test_GivenAlignment_WhenJustified_ThenInsetsZero),
        ("test_GivenStartAlignment_WhenEqualsIgnoreValues_ThenFalse", test_GivenStartAlignment_WhenEqualsIgnoreValues_ThenFalse),
        ("test_GivenCenterAlignment_WhenInsets_ThenZero", test_GivenCenterAlignment_WhenInsets_ThenZero),
        ("test_GivenEndAlignment_WhenInsets_ThenInsets", test_GivenEndAlignment_WhenInsets_ThenInsets),
        ("test_GivenStartAlignment_WhenInsets_ThenInsets", test_GivenStartAlignment_WhenInsets_ThenInsets),
        ("test_GivenJustifiedAlignment_WhenInsets_ThenInsets", test_GivenJustifiedAlignment_WhenInsets_ThenInsets)
    ]

}
