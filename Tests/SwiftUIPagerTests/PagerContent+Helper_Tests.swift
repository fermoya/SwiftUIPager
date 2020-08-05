import XCTest
import SwiftUI
@testable import SwiftUIPager

final class PagerContent_Helper_Tests: XCTestCase {

    var givenPager: Pager<Int, Int, Text>.PagerContent {
        Pager.PagerContent(size: CGSize(width: 300, height: 300), page: .constant(0), data: Array(0..<20), id: \.self) {
            Text("\($0)")
        }
    }

    func test_GivenPager_WhenIsFocused_ThenTrue() {
        let pager = givenPager
        let output = pager.isFocused(PageWrapper(batchId: 1, keyPath: \.self, element: 0))
        XCTAssertTrue(output)
    }

    func test_GivenPager_WhenIsFocused_ThenFalse() {
        let pager = givenPager
        let output = pager.isFocused(PageWrapper(batchId: 1, keyPath: \.self, element: 1))
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

    func test_GivenPager_WhenScaleForItem_Then1() {
        let pager = givenPager.interactive(0.7)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 0)
        let scale = pager.scale(for: item)
        XCTAssertEqual(scale, 1)
    }

    func test_GivenPager_WhenScaleForItem_ThenExpectedValue() {
        let pager = givenPager.interactive(0.7)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 1)
        let scale = pager.scale(for: item)
        XCTAssertEqual(scale, 0.7)
    }

    func test_GivenPagerDragging_WhenScaleForItem_ThenLessThanOne() {
        let pager = givenPager.interactive(0.7).pageOffset(0.1)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 1)
        let scale = pager.scale(for: item)
        XCTAssertLessThan(scale, 1)
    }

    func test_GivenPagerDragging_WhenScaleForItem_ThenGreaterThanInteractive() {
        let pager = givenPager.interactive(0.7).pageOffset(0.1)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 1)
        let scale = pager.scale(for: item)
        XCTAssertGreaterThan(scale, 0.7)
    }

    func test_GivenPagerDragging_WhenScaleForNonExistingItem_ThenInteractiveScale() {
        let pager = givenPager.interactive(0.7).pageOffset(0.1)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 200)
        let scale = pager.scale(for: item)
        XCTAssertEqual(scale, 0.7)
    }

    func test_GivenPagerDragging_WhenScaleForFarItem_ThenInteractiveScale() {
        let pager = givenPager.interactive(0.7).pageOffset(-0.1)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 3)
        let scale = pager.scale(for: item)
        XCTAssertEqual(scale, 0.7)
    }

    func test_GivenPagerDragging_WhenScaleBouncing_ThenLessThanZero() {
        let pager = givenPager.interactive(0.7).pageOffset(-0.1)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 1)
        let scale = pager.scale(for: item)
        XCTAssertLessThan(scale, 1)
    }

    func test_GivenPagerDragging_WhenCurrentPage_ThenThree() {
        let pager = givenPager.pageOffset(2.6)
        let currentPage = pager.currentPage
        XCTAssertEqual(currentPage, 3)
    }

    func test_GivenInfinitePagerDragging_WhenCurrentPage_Then19() {
        let pager = givenPager.pageOffset(-1).loopPages()
        let currentPage = pager.currentPage
        XCTAssertEqual(currentPage, 19)
    }

    func test_GivenPager_WhenDataDisplayed_ThenExpectedValues() {
        let pager = givenPager
        let dataDisplayed = pager.dataDisplayed.map { $0.element }
        XCTAssertEqual(dataDisplayed, [0, 1, 2])
        XCTAssertEqual(pager.lowerPageDisplayed, 0)
        XCTAssertEqual(pager.upperPageDisplayed, 2)
        XCTAssertEqual(pager.numberOfPagesDisplayed, 3)
    }

    func test_GivenInfinitePager_WhenDataDisplayed_ThenExpectedValues() {
        let pager = givenPager.loopPages()
        let dataDisplayed = pager.dataDisplayed.map { $0.element }
        XCTAssertEqual(dataDisplayed, [18, 19, 0, 1, 2])
        XCTAssertEqual(pager.lowerPageDisplayed, 18)
        XCTAssertEqual(pager.upperPageDisplayed, 3)
        XCTAssertEqual(pager.numberOfPagesDisplayed, 5)
    }
    
    static var allTests = [
        ("test_GivenInfinitePager_WhenDataDisplayed_ThenExpectedValues", test_GivenInfinitePager_WhenDataDisplayed_ThenExpectedValues),
        ("test_GivenPager_WhenDataDisplayed_ThenExpectedValues", test_GivenPager_WhenDataDisplayed_ThenExpectedValues),
        ("test_GivenInfinitePagerDragging_WhenCurrentPage_Then19", test_GivenInfinitePagerDragging_WhenCurrentPage_Then19),
        ("test_GivenPagerDragging_WhenCurrentPage_ThenThree", test_GivenPagerDragging_WhenCurrentPage_ThenThree),
        ("test_GivenPagerDragging_WhenScaleBouncing_ThenLessThanZero", test_GivenPagerDragging_WhenScaleBouncing_ThenLessThanZero),
        ("test_GivenPagerDragging_WhenScaleForFarItem_ThenInteractiveScale", test_GivenPagerDragging_WhenScaleForFarItem_ThenInteractiveScale),
        ("test_GivenPagerDragging_WhenScaleForNonExistingItem_ThenInteractiveScale", test_GivenPagerDragging_WhenScaleForNonExistingItem_ThenInteractiveScale),
        ("test_GivenPagerDragging_WhenScaleForItem_ThenGreaterThanInteractive", test_GivenPagerDragging_WhenScaleForItem_ThenGreaterThanInteractive),
        ("test_GivenPagerDragging_WhenScaleForItem_ThenLessThanOne", test_GivenPagerDragging_WhenScaleForItem_ThenLessThanOne),
        ("test_GivenPager_WhenScaleForItem_Then1", test_GivenPager_WhenScaleForItem_Then1),
        ("test_GivenPager_WhenScaleForItem_ThenExpectedValue", test_GivenPager_WhenScaleForItem_ThenExpectedValue),
        ("test_GivenPager_WhenScaleIncrement_ThenZero", test_GivenPager_WhenScaleIncrement_ThenZero),
        ("test_GivenInteractivePager_WhenScaleIncrement_ThenInteractiveScaleInverse", test_GivenInteractivePager_WhenScaleIncrement_ThenInteractiveScaleInverse),
        ("test_GivenPager_WhenNumberOfPages_ThenDataCount", test_GivenPager_WhenNumberOfPages_ThenDataCount),
        ("test_GivenPager_WhenAxisForItem_ThenZero", test_GivenPager_WhenAxisForItem_ThenZero),
        ("test_GivenPagerWithRotation_WhenAxisForItem_ThenRotationAxis", test_GivenPagerWithRotation_WhenAxisForItem_ThenRotationAxis),
        ("test_GivenPager_WhenIsFocused_ThenTrue", test_GivenPager_WhenIsFocused_ThenTrue),
        ("test_GivenPager_WhenIsFocused_ThenFalse", test_GivenPager_WhenIsFocused_ThenFalse)
    ]
}
