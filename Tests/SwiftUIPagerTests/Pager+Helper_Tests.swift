import XCTest
import SwiftUI
@testable import SwiftUIPager

final class Pager_Helper_Tests: XCTestCase {
    
    var givenPager: Pager<Int, Int, Text> {
        Pager(page: .constant(0), data: Array(1..<20), id: \.self) {
            Text("\($0)")
        }
    }
    
    func test_GivenPager_WhenScaleIncrement_ThenZero() {
        let pager = givenPager
        let scaleIncrement = pager.scaleIncrement
        XCTAssertEqual(scaleIncrement, 0)
    }
    
    func test_GivenInteractivePager_WhenScaleIncrement_ThenInteractiveScaleInverse() {
        let pager = givenPager.interactive(0.7)
        let scaleIncrement = pager.scaleIncrement
        XCTAssertEqual(scaleIncrement, 0.3)
    }
    
    static var allTests = [
        ("test_GivenPager_WhenScaleIncrement_ThenZero", test_GivenPager_WhenScaleIncrement_ThenZero),
        ("test_GivenInteractivePager_WhenScaleIncrement_ThenInteractiveScaleInverse", test_GivenInteractivePager_WhenScaleIncrement_ThenInteractiveScaleInverse),
    ]
}
