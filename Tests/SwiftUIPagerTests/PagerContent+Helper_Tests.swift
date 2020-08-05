import XCTest
import SwiftUI
@testable import SwiftUIPager

final class PagerContent_Helper_Tests: XCTestCase {

    var givenPager: Pager<Int, Int, Text>.PagerContent {
        Pager.PagerContent(size: CGSize(width: 300, height: 300), page: .constant(0), data: Array(1..<20), id: \.self) {
            Text("\($0)")
        }
    }

    func test_GivenPager_WhenIsFocused_ThenTrue() {
        let pager = givenPager
        let output = pager.isFocused(PageWrapper(batchId: 1, keyPath: \.self, element: 1))
        XCTAssertTrue(output)
    }

    func test_GivenPager_WhenIsFocused_ThenFalse() {
        let pager = givenPager
        let output = pager.isFocused(PageWrapper(batchId: 1, keyPath: \.self, element: 2))
        XCTAssertFalse(output)
    }
    
    func test_GivenPager_WhenScaleIncrement_ThenZero() {
        let pager = givenPager
        let scaleIncrement = pager.scaleIncrement
        XCTAssertEqual(scaleIncrement, 0)
    }
    
    func test_GivenInteractivePager_WhenScaleIncrement_ThenInteractiveScaleInverse() {
        let pager = givenPager.interactive(0.7)
        let scaleIncrement = pager.scaleIncrement
        XCTAssertEqual(Int(scaleIncrement * 10), 3)
    }

    func test_GivenPager_WhenNumberOfPages_ThenDataCount() {
        let pager = givenPager
        XCTAssertEqual(pager.numberOfPages, pager.data.count)
    }

    func test_GivenPager_WhenAxisForItem_ThenZero() {
        let pager = givenPager
        let (x, y, z) = pager.axis
        XCTAssertEqual(x, 0)
        XCTAssertEqual(y, 0)
        XCTAssertEqual(z, 0)
    }

    func test_GivenPagerWithRotation_WhenAxisForItem_ThenRotationAxis() {
        let pager = givenPager.rotation3D()
        let (x, y, z) = pager.axis
        XCTAssertEqual(x, pager.rotationAxis.x)
        XCTAssertEqual(y, pager.rotationAxis.y)
        XCTAssertEqual(z, pager.rotationAxis.z)
    }
    
    static var allTests = [
        ("test_GivenPager_WhenScaleIncrement_ThenZero", test_GivenPager_WhenScaleIncrement_ThenZero),
        ("test_GivenInteractivePager_WhenScaleIncrement_ThenInteractiveScaleInverse", test_GivenInteractivePager_WhenScaleIncrement_ThenInteractiveScaleInverse),
        ("test_GivenPager_WhenNumberOfPages_ThenDataCount", test_GivenPager_WhenNumberOfPages_ThenDataCount),
        ("test_GivenPager_WhenAxisForItem_ThenZero", test_GivenPager_WhenAxisForItem_ThenZero),
        ("test_GivenPagerWithRotation_WhenAxisForItem_ThenRotationAxis", test_GivenPagerWithRotation_WhenAxisForItem_ThenRotationAxis),
        ("test_GivenPager_WhenIsFocused_ThenTrue", test_GivenPager_WhenIsFocused_ThenTrue),
        ("test_GivenPager_WhenIsFocused_ThenFalse", test_GivenPager_WhenIsFocused_ThenFalse)
    ]
}
