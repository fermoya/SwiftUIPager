import XCTest
import SwiftUI
@testable import SwiftUIPager

final class PagerContent_Helper_Tests: XCTestCase {

    var givenPager: Pager<Int, Int, Text>.PagerContent {
        Pager.PagerContent(size: CGSize(width: 300, height: 300), pagerModel: .first(), data: Array(0..<20), id: \.self) {
            Text("\($0)")
        }
    }

    func test_GivenPager_WhenPagerModelHelpers_ThenSameValues() {
        let pagerContent = givenPager
        pagerContent.pagerModel.draggingVelocity = -100
        pagerContent.pagerModel.lastDraggingValue = .unsafeInit()
        pagerContent.pagerModel.draggingOffset = 200
        
        XCTAssertEqual(pagerContent.pagerModel.draggingVelocity, pagerContent.draggingVelocity)
        XCTAssertEqual(pagerContent.pagerModel.lastDraggingValue, pagerContent.lastDraggingValue)
        XCTAssertEqual(pagerContent.pagerModel.draggingOffset, pagerContent.draggingOffset)
    }

    func test_GivenPager_WhenOpacity_ThenOne() {
        XCTAssertEqual(givenPager.opacity(for: PageWrapper(batchId: 1, keyPath: \.self, element: 1)), 1)
    }

    func test_GivenPager_WhenOpacityForNotFoundIndex_ThenOne() {
        let pager = givenPager.interactive(opacity: 0.3)
        XCTAssertEqual(pager.opacity(for: PageWrapper(batchId: 0, keyPath: \.self, element: -1)), 1)
    }

    func test_GivenFadedPager_WhenOpacityForNotFoundIndex_ThenValues() {
        let pagerContent = givenPager.interactive(opacity: 0.3)
        pagerContent.pagerModel.index = 2

        let focusedItem = PageWrapper(batchId: 1, keyPath: \.self, element: 2)
        let neighbor1 = PageWrapper(batchId: 1, keyPath: \.self, element: 1)
        let neighbor2 = PageWrapper(batchId: 1, keyPath: \.self, element: 3)
        let neighbor3 = PageWrapper(batchId: 1, keyPath: \.self, element: 4)
        XCTAssertEqual(pagerContent.opacity(for: focusedItem), 1)
        XCTAssertEqual(Int((pagerContent.opacity(for: neighbor1) * 10).rounded()), 7)
        XCTAssertEqual(Int((pagerContent.opacity(for: neighbor2) * 10).rounded()), 7)
        XCTAssertEqual(Int((pagerContent.opacity(for: neighbor3) * 10).rounded()), 4)
    }

    func test_GivenFadedPagerMovingForward_WhenOpacityForNotFoundIndex_ThenValues() {
        let pagerContent = givenPager.interactive(opacity: 0.4)
        pagerContent.pagerModel.index = 2
        pagerContent.pagerModel.draggingOffset = -150

        let focusedItem = PageWrapper(batchId: 1, keyPath: \.self, element: 2)
        let neighbor1 = PageWrapper(batchId: 1, keyPath: \.self, element: 1)
        let neighbor2 = PageWrapper(batchId: 1, keyPath: \.self, element: 3)
        let neighbor3 = PageWrapper(batchId: 1, keyPath: \.self, element: 4)
        XCTAssertEqual(Int((pagerContent.opacity(for: focusedItem) * 10).rounded()), 8)
        XCTAssertEqual(Int((pagerContent.opacity(for: neighbor1) * 10).rounded()), 4)
        XCTAssertEqual(Int((pagerContent.opacity(for: neighbor2) * 10).rounded()), 8)
        XCTAssertEqual(Int((pagerContent.opacity(for: neighbor3) * 10).rounded()), 4)
    }

    func test_GivenMultiplePaginationPager_WhenDragResult_ThenValues() {
        let pagerContent = givenPager.multiplePagination()
        pagerContent.pagerModel.draggingOffset = -pagerContent.size.width * 2
        let result = pagerContent.dragResult
        XCTAssertEqual(result.page, 2)
        XCTAssertEqual(result.increment, 2)
    }

    func test_GivenInfinitePager_WhenDragLeft_ThenLastPage() {
        let pagerContent = givenPager.loopPages()
        pagerContent.pagerModel.draggingOffset = pagerContent.size.width / 10
        pagerContent.pagerModel.draggingVelocity = 600
        let result = pagerContent.dragResult
        XCTAssertEqual(result.page, pagerContent.numberOfPages - 1)
        XCTAssertEqual(result.increment, 1)
    }

    func test_GivenInfiniteMultiplePaginationPager_WhenDragLeft_ThenRightPage() {
        let pagerContent = givenPager.loopPages().multiplePagination()
        pagerContent.pagerModel.draggingOffset = pagerContent.size.width * 3
        pagerContent.pagerModel.draggingVelocity = 600
        let result = pagerContent.dragResult
        XCTAssertEqual(result.page, pagerContent.numberOfPages - 4)
        XCTAssertEqual(result.increment, 4)
    }

    func test_GivenPager_WhenDragQuickly_ThenIncrementPage() {
        let pagerContent = givenPager
        pagerContent.pagerModel.draggingOffset = -pagerContent.size.width / 4
        pagerContent.pagerModel.draggingVelocity = -600
        let result = pagerContent.dragResult
        XCTAssertEqual(result.page, 1)
        XCTAssertEqual(result.increment, 1)
    }
    
    func test_GivenPager_WhenScaleIncrement_ThenZero() {
        let pager = givenPager
        let scaleIncrement = pager.scaleIncrement
        XCTAssertEqual(scaleIncrement, 0)
    }
    
    func test_GivenInteractivePager_WhenScaleIncrement_ThenInteractiveScaleInverse() {
        let pager = givenPager.interactive(scale: 0.7)
        let scaleIncrement = pager.scaleIncrement
        XCTAssertEqual(Int((scaleIncrement * 10).rounded()), 3)
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
        let pager = givenPager.interactive(rotation: true)
        let (x, y, z) = pager.axis
        XCTAssertEqual(x, pager.rotationAxis.x)
        XCTAssertEqual(y, pager.rotationAxis.y)
        XCTAssertEqual(z, pager.rotationAxis.z)
    }

    func test_GivenPager_WhenScaleForItem_Then1() {
        let pager = givenPager.interactive(scale: 0.7)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 0)
        let scale = pager.scale(for: item)
        XCTAssertEqual(scale, 1)
    }

    func test_GivenPager_WhenScaleForItem_ThenExpectedValue() {
        let pager = givenPager.interactive(scale: 0.7)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 1)
        let scale = pager.scale(for: item)
        XCTAssertEqual(scale, 0.7)
    }

    func test_GivenPagerDragging_WhenScaleForItem_ThenLessThanOne() {
        let pager = givenPager.interactive(scale: 0.7).pageOffset(0.1)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 1)
        let scale = pager.scale(for: item)
        XCTAssertLessThan(scale, 1)
    }

    func test_GivenPagerDragging_WhenScaleForItem_ThenGreaterThanInteractive() {
        let pager = givenPager.interactive(scale: 0.7).pageOffset(0.1)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 1)
        let scale = pager.scale(for: item)
        XCTAssertGreaterThan(scale, 0.7)
    }

    func test_GivenPagerDragging_WhenScaleForNonExistingItem_ThenInteractiveScale() {
        let pager = givenPager.interactive(scale: 0.7).pageOffset(0.1)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 200)
        let scale = pager.scale(for: item)
        XCTAssertEqual(scale, 1)
    }

    func test_GivenPagerDragging_WhenScaleForFarItem_ThenInteractiveScale() {
        let pager = givenPager.interactive(scale: 0.7).pageOffset(-0.1)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 2)
        let scale = pager.scale(for: item)
        XCTAssertEqual(scale, 0.7)
    }

    func test_GivenPagerDragging_WhenScaleBouncing_ThenLessThanZero() {
        let pager = givenPager.interactive(scale: 0.7).pageOffset(-0.1)
        let item = PageWrapper(batchId: 1, keyPath: \.self, element: 1)
        let scale = pager.scale(for: item)
        XCTAssertLessThan(scale, 1)
    }

    func test_GivenPagerDragging_WhenCurrentPage_ThenThree() {
        let pager = givenPager.pageOffset(2.6)
        let currentPage = pager.currentPage
        XCTAssertEqual(currentPage, 3)
    }

    func test_GivenHighSensitivePager_WhenCurrentPage_ThenThree() {
        let pager = givenPager.pageOffset(2.25)
        let currentPage = pager.currentPage(sensitivity: PaginationSensitivity.high.value)
        XCTAssertEqual(currentPage, 3)
    }

    func test_GivenHighSensitivePager_WhenCurrentPage_ThenTwo() {
        let pager = givenPager.pageOffset(2.24)
        let currentPage = pager.currentPage(sensitivity: PaginationSensitivity.high.value)
        XCTAssertEqual(currentPage, 2)
    }

    func test_GivenCustomSensitivePager_WhenCurrentPage_ThenTwo() {
        let pager = givenPager.pageOffset(2.42)
        let currentPage = pager.currentPage(sensitivity: PaginationSensitivity.custom(0.43).value)
        XCTAssertEqual(currentPage, 2)
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

    func test_GivenHorizontalPagerStartAligned_WhenAlignmentOffset_ThenExpectedValue() {
        let pager = givenPager.alignment(.start(5)).padding(10).horizontal()
        let offset = pager.alignmentOffset
        XCTAssertEqual(offset, -5)
    }

    func test_GivenVerticalPagerStartAligned_WhenAlignmentOffset_ThenExpectedValue() {
        let pager = givenPager.alignment(.start).padding(10).vertical()
        let offset = pager.alignmentOffset
        XCTAssertEqual(offset, -10)
    }

    func test_GivenHorizontalPagerEndAligned_WhenAlignmentOffset_ThenExpectedValue() {
        let pager = givenPager.alignment(.end(5)).padding(10).horizontal()
        let offset = pager.alignmentOffset
        XCTAssertEqual(offset, 5)
    }

    func test_GivenVerticalPagerEndAligned_WhenAlignmentOffset_ThenExpectedValue() {
        let pager = givenPager.alignment(.end).padding(10).vertical()
        let offset = pager.alignmentOffset
        XCTAssertEqual(offset, 10)
    }

    func test_GivenHorizontalPagerStartCenter_WhenAlignmentOffset_ThenExpectedValue() {
        let pager = givenPager.alignment(.center).padding(10).horizontal()
        let offset = pager.alignmentOffset
        XCTAssertEqual(offset, 0)
    }

    func test_GivenVerticalPagerStartCenter_WhenAlignmentOffset_ThenExpectedValue() {
        let pager = givenPager.alignment(.center).padding(10).vertical()
        let offset = pager.alignmentOffset
        XCTAssertEqual(offset, 0)
    }

    func test_GivenHorizontalPagerStartJustified_WhenAlignmentOffset_ThenExpectedValue() {
        let pager = givenPager.alignment(.justified).padding(10).horizontal()
        let offset = pager.alignmentOffset
        XCTAssertEqual(offset, -10)
    }

    func test_GivenVerticalPagerStartJustified_WhenAlignmentOffset_ThenExpectedValue() {
        let pager = givenPager.alignment(.justified).padding(10).vertical()
        let offset = pager.alignmentOffset
        XCTAssertEqual(offset, -10)
    }

    func test_GivenPagerItemAlignedCenter_WhenYOffset_ThenZero() {
        let pager = givenPager.itemAspectRatio(nil, alignment: .center)
        let offset = pager.yOffset
        XCTAssertEqual(offset, 0)
    }

    func test_GivenPagerItemAlignedJustified_WhenYOffset_ThenZero() {
        let pager = givenPager.itemAspectRatio(nil, alignment: .justified)
        let offset = pager.yOffset
        XCTAssertEqual(offset, 0)
    }

    func test_GivenPagerItemAlignedStart_WhenYOffset_ThenExpectedValue() {
        let pager = givenPager.preferredItemSize(CGSize(width: 100, height: 100), alignment: .start)
        let offset = pager.yOffset
        XCTAssertEqual(offset, -100)
    }

    func test_GivenPagerItemAlignedEnd_WhenYOffset_ThenExpectedValue() {
        let pager = givenPager.preferredItemSize(CGSize(width: 150, height: 100), alignment: .end).vertical()
        let offset = pager.yOffset
        XCTAssertEqual(offset, -75)
    }

    func test_GivenPagerItemAlignedEnd_WhenYOffset_ThenZero() {
        let pager = givenPager.preferredItemSize(CGSize(width: 300, height: 300), alignment: .end).vertical()
        let offset = pager.yOffset
        XCTAssertEqual(offset, 0)
    }

    func test_GivenPager_WhenXOffset_ThenExpectedValue() {
        let pager = givenPager
        let offset = pager.xOffset
        XCTAssertEqual(offset, 300)
    }

    func test_GivenPagerOffset2_WhenXOffset_ThenExpectedValue() {
        let pager = givenPager.pageOffset(2)
        let offset = pager.xOffset
        XCTAssertEqual(offset, -300)
    }

    func test_GivenPager_WhenAngle_ThenZero() {
        let pager = givenPager
        let angle = pager.angle(for: .init(batchId: 1, keyPath: \.self, element: 0))
        XCTAssertEqual(angle, .zero)
    }

    func test_GivenPagerWithRotation3D_WhenAngle_ThenZero() {
        let pager = givenPager.interactive(rotation: true)
        let angle = pager.angle(for: .init(batchId: 1, keyPath: \.self, element: 0))
        XCTAssertEqual(angle, .zero)
    }

    func test_GivenPagerWithRotation3DDraggingForward_WhenAngle_ThenGreaterThanZero() {
        let pager = givenPager.interactive(rotation: true).pageOffset(1.1)
        let angle = pager.angle(for: .init(batchId: 1, keyPath: \.self, element: 0))
        XCTAssertGreaterThan(angle.degrees, .zero)
    }

    func test_GivenPagerWithRotation3DDraggingBackward_WhenAngle_ThenLessThanZero() {
        let pager = givenPager.interactive(rotation: true).pageOffset(-0.1)
        let angle = pager.angle(for: .init(batchId: 1, keyPath: \.self, element: 0))
        XCTAssertLessThan(angle.degrees, .zero)
    }

    func test_GivenPagerDragging_WhenIsEdgePage_ThenFalse() {
        let pager = givenPager.pageOffset(0.1)
        let isEdgePage = pager.isEdgePage(.init(batchId: 1, keyPath: \.self, element: 0))
        XCTAssertFalse(isEdgePage)
    }

    func test_GivenPager_WhenIsEdgePage_ThenTrue() {
        let pager = givenPager.loopPages()
        XCTAssertTrue(pager.isEdgePage(.init(batchId: 1, keyPath: \.self, element: 18)))
        XCTAssertTrue(pager.isEdgePage(.init(batchId: 1, keyPath: \.self, element: 2)))
        XCTAssertFalse(pager.isEdgePage(.init(batchId: 1, keyPath: \.self, element: 1)))
    }
    
    static var allTests = [
        ("test_GivenPager_WhenIsEdgePage_ThenTrue", test_GivenPager_WhenIsEdgePage_ThenTrue),
        ("test_GivenPagerDragging_WhenIsEdgePage_ThenFalse", test_GivenPagerDragging_WhenIsEdgePage_ThenFalse),
        ("test_GivenPagerWithRotation3DDraggingForward_WhenAngle_ThenGreaterThanZero", test_GivenPagerWithRotation3DDraggingForward_WhenAngle_ThenGreaterThanZero),
        ("test_GivenPagerWithRotation3DDraggingBackward_WhenAngle_ThenLessThanZero", test_GivenPagerWithRotation3DDraggingBackward_WhenAngle_ThenLessThanZero),
        ("test_GivenPager_WhenAngle_ThenZero", test_GivenPager_WhenAngle_ThenZero),
        ("test_GivenPagerWithRotation3D_WhenAngle_ThenZero", test_GivenPagerWithRotation3D_WhenAngle_ThenZero),
        ("test_GivenPager_WhenXOffset_ThenExpectedValue", test_GivenPager_WhenXOffset_ThenExpectedValue),
        ("test_GivenPagerOffset2_WhenXOffset_ThenExpectedValue", test_GivenPagerOffset2_WhenXOffset_ThenExpectedValue),
        ("test_GivenPagerItemAlignedEnd_WhenYOffset_ThenZero", test_GivenPagerItemAlignedEnd_WhenYOffset_ThenZero),
        ("test_GivenPagerItemAlignedEnd_WhenYOffset_ThenExpectedValue", test_GivenPagerItemAlignedEnd_WhenYOffset_ThenExpectedValue),
        ("test_GivenPagerItemAlignedStart_WhenYOffset_ThenExpectedValue", test_GivenPagerItemAlignedStart_WhenYOffset_ThenExpectedValue),
        ("test_GivenPagerItemAlignedJustified_WhenYOffset_ThenZero", test_GivenPagerItemAlignedJustified_WhenYOffset_ThenZero),
        ("test_GivenHorizontalPagerStartAligned_WhenAlignmentOffset_ThenExpectedValue", test_GivenHorizontalPagerStartAligned_WhenAlignmentOffset_ThenExpectedValue),
        ("test_GivenVerticalPagerStartAligned_WhenAlignmentOffset_ThenExpectedValue", test_GivenVerticalPagerStartAligned_WhenAlignmentOffset_ThenExpectedValue),
        ("test_GivenHorizontalPagerEndAligned_WhenAlignmentOffset_ThenExpectedValue", test_GivenHorizontalPagerEndAligned_WhenAlignmentOffset_ThenExpectedValue),
        ("test_GivenVerticalPagerEndAligned_WhenAlignmentOffset_ThenExpectedValue", test_GivenVerticalPagerEndAligned_WhenAlignmentOffset_ThenExpectedValue),
        ("test_GivenHorizontalPagerStartCenter_WhenAlignmentOffset_ThenExpectedValue", test_GivenHorizontalPagerStartCenter_WhenAlignmentOffset_ThenExpectedValue),
        ("test_GivenVerticalPagerStartCenter_WhenAlignmentOffset_ThenExpectedValue", test_GivenVerticalPagerStartCenter_WhenAlignmentOffset_ThenExpectedValue),
        ("test_GivenHorizontalPagerStartJustified_WhenAlignmentOffset_ThenExpectedValue", test_GivenHorizontalPagerStartJustified_WhenAlignmentOffset_ThenExpectedValue),
        ("test_GivenVerticalPagerStartJustified_WhenAlignmentOffset_ThenExpectedValue", test_GivenVerticalPagerStartJustified_WhenAlignmentOffset_ThenExpectedValue),
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
        ("test_GivenHighSensitivePager_WhenCurrentPage_ThenThree", test_GivenHighSensitivePager_WhenCurrentPage_ThenThree),
        ("test_GivenHighSensitivePager_WhenCurrentPage_ThenTwo", test_GivenHighSensitivePager_WhenCurrentPage_ThenTwo),
        ("test_GivenCustomSensitivePager_WhenCurrentPage_ThenTwo", test_GivenCustomSensitivePager_WhenCurrentPage_ThenTwo),
        ("test_GivenPager_WhenPagerModelHelpers_ThenSameValues", test_GivenPager_WhenPagerModelHelpers_ThenSameValues),
        ("test_GivenMultiplePaginationPager_WhenDragResult_ThenValues", test_GivenMultiplePaginationPager_WhenDragResult_ThenValues),
        ("test_GivenPager_WhenDragQuickly_ThenIncrementPage", test_GivenPager_WhenDragQuickly_ThenIncrementPage),
        ("test_GivenInfinitePager_WhenDragLeft_ThenLastPage", test_GivenInfinitePager_WhenDragLeft_ThenLastPage),
        ("test_GivenPager_WhenOpacity_ThenOne", test_GivenPager_WhenOpacity_ThenOne),
        ("test_GivenPager_WhenOpacityForNotFoundIndex_ThenOne", test_GivenPager_WhenOpacityForNotFoundIndex_ThenOne),
        ("test_GivenFadedPager_WhenOpacityForNotFoundIndex_ThenValues", test_GivenFadedPager_WhenOpacityForNotFoundIndex_ThenValues),
        ("test_GivenFadedPagerMovingForward_WhenOpacityForNotFoundIndex_ThenValues", test_GivenFadedPagerMovingForward_WhenOpacityForNotFoundIndex_ThenValues)
    ]
}
