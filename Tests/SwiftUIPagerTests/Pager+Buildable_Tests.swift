import XCTest
import SwiftUI
@testable import SwiftUIPager

extension Int: Identifiable {
    public var id: Int { return self }
}

final class Pager_Buildable_Tests: XCTestCase {

    var givenPager: Pager<Int, Int, Text> {
        Pager(page: .first(), data: Array(0..<20)) {
            Text("\($0)")
        }
    }

    func test_GivenPager_ThenDefaultValues() {
        let pager = givenPager
        XCTAssertNil(pager.itemAspectRatio)
        XCTAssertTrue(pager.isHorizontal)
        XCTAssertTrue(pager.allowsDragging)
        XCTAssertFalse(pager.isInifinitePager)
        XCTAssertEqual(pager.horizontalSwipeDirection, HorizontalSwipeDirection.leftToRight)
        XCTAssertEqual(pager.verticalSwipeDirection, VerticalSwipeDirection.topToBottom)
        XCTAssertEqual(pager.interactiveScale, 1)
        XCTAssertEqual(pager.alignment, .center)
        XCTAssertFalse(pager.shouldRotate)
        XCTAssertEqual(pager.pageOffset, 0)
        XCTAssertEqual(pager.sideInsets, 0)
        XCTAssertEqual(pager.itemSpacing, 0)
        XCTAssertEqual(pager.itemAlignment, .center)
        XCTAssertEqual(pager.swipeInteractionArea, .page)
        XCTAssertTrue(pager.delaysTouches)
        XCTAssertEqual(pager.gesturePriority, .default)
        XCTAssertEqual(pager.contentLoadingPolicy, .default)
        XCTAssertEqual(pager.allowsMultiplePagination, false)
        XCTAssertNil(pager.pagingAnimation)
        XCTAssertEqual(pager.draggingAnimation, PagingAnimation.standard)
        XCTAssertEqual(pager.sensitivity, .default)
        XCTAssertEqual(pager.pageRatio, 1)
        XCTAssertTrue(pager.bounces)
        XCTAssertNil(pager.opacityIncrement)
        XCTAssertFalse(pager.dragForwardOnly)

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertNil(pagerContent.direction)
        XCTAssertEqual(pagerContent.minimumDistance, 15)
        XCTAssertFalse(pagerContent.isDragging)
    }

    func test_GivenPager_WhenFaded_ThenOpacityIncrementChanges() {
        var pager = givenPager
        pager = pager.interactive(opacity: 0.2)

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.opacityIncrement, 0.2)
    }

    func test_GivenPager_WhenSinglePagination_ThenRatioChanges() {
        var pager = givenPager
        pager = pager.singlePagination(ratio: 0.33, sensitivity: .high)

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.sensitivity, .high)
        XCTAssertEqual(pagerContent.pageRatio, 0.33)
    }

    func test_GivenPager_WhenSinglePaginationNegativeValue_ThenRatioZero() {
        var pager = givenPager
        pager = pager.singlePagination(ratio: -0.33, sensitivity: .high)

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.sensitivity, .high)
        XCTAssertEqual(pagerContent.pageRatio, 0)
    }

    func test_GivenPager_WhenSinglePaginationTooLarge_ThenRatio1() {
        var pager = givenPager
        pager = pager.singlePagination(ratio: 1.2, sensitivity: .high)

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.sensitivity, .high)
        XCTAssertEqual(pagerContent.pageRatio, 1)
    }

    func test_GivenMultiplePaginationPager_WhenSinglePagination_ThenAllowsMultiplePaginationFalse() {
        var pager = givenPager.multiplePagination()
        pager = pager.singlePagination()

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertFalse(pagerContent.allowsMultiplePagination)
    }

    func test_GivenPager_WhenSensitivityHigh_ThenSensitivityHigh() {
        var pager = givenPager
        pager = pager.sensitivity(.high)

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.sensitivity, .high)
    }

    func test_GivenPager_WhenDelaysTouchesFalse_ThenMinimumDistanceZero() {
        var pager = givenPager
        pager = pager.delaysTouches(false)

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.minimumDistance, 0)
    }

    func test_GivenPager_WhenPagingAnimation_ThenPagingAnimationNotNil() throws {
        var pager = givenPager
        pager = pager.pagingAnimation({ _ in .steep })
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        let pagingAnimation = try XCTUnwrap(pagerContent.pagingAnimation?((0, 0, 0, 0)))
        XCTAssertEqual(pagingAnimation, PagingAnimation.steep)
    }

    func test_GivenPager_WhenDraggingAnimation_ThenDraggingAnimationNotNil() throws {
        var pager = givenPager
        pager = pager.draggingAnimation(.steep)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        let animation = try XCTUnwrap(pagerContent.draggingAnimation)
        XCTAssertEqual(animation, PagingAnimation.steep)
    }

    func test_GivenPager_WhenDraggingAnimation_ThenDraggingAndPagingAnimationNotNil() throws {
        var pager = givenPager
        pager = pager.draggingAnimation(onChange: .interactive, onEnded: .steep)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        let anim1 = try XCTUnwrap(pagerContent.draggingAnimation)
        let anim2 = try XCTUnwrap(pagerContent.pagingAnimation?((0, 0, 0, 0)))
        XCTAssertEqual(anim1, PagingAnimation.interactive)
        XCTAssertEqual(anim2, PagingAnimation.steep)
    }

    func test_GivenPager_WhenMultiplePagination_ThenAllowsMultiplePagination() {
        var pager = givenPager
        pager = pager.multiplePagination()
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertTrue(pagerContent.allowsMultiplePagination)
        XCTAssertEqual(pagerContent.contentLoadingPolicy, .eager)
        XCTAssertEqual(pagerContent.maximumNumberOfPages, pagerContent.numberOfPages)
        XCTAssertEqual(pagerContent.upperPageDisplayed, pagerContent.numberOfPages - 1)
    }

    func test_GivenPager_WhenContentLoadingPolicyLazy0_ThenRecyclingRatioIs1() {
        var pager = givenPager
        pager = pager.contentLoadingPolicy(.lazy(recyclingRatio: 0))
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.recyclingRatio, 1)
    }

    func test_GivenPager_WhenContentLoadingPolicyLazy10_ThenRecyclingRatioIs10() {
        var pager = givenPager
        pager = pager.contentLoadingPolicy(.lazy(recyclingRatio: 10))
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.recyclingRatio, 10)
    }

    func test_GivenPager_WhenContentLoadingPolicyEager_ThenRecyclingRatioIsIntMax() {
        var pager = givenPager
        pager = pager.contentLoadingPolicy(.eager)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.recyclingRatio, pagerContent.numberOfPages)
    }

    func test_GivenPager_WhenPagingPrioritySimultaneous_ThenSimultaneous() {
        var pager = givenPager
        pager = pager.pagingPriority(.simultaneous)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.gesturePriority, .simultaneous)
    }

    func test_GivenPager_WhenPagingPriorityHigh_ThenHigh() {
        var pager = givenPager
        pager = pager.pagingPriority(.high)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.gesturePriority, .high)
    }

    func test_GivenPager_WhenPreferredItemSize_ThenNotNil() {
        var pager = givenPager.itemAspectRatio(0.7)
        pager = pager.preferredItemSize(CGSize(width: 50, height: 50))
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertNil(pagerContent.itemAspectRatio)
        XCTAssertNotNil(pagerContent.preferredItemSize)
        XCTAssertEqual(pagerContent.sideInsets, 0)
    }

    func test_GivenPager_WhenLoopPages_ThenIsInfinitePagerTrue() {
        var pager = givenPager
        pager = pager.loopPages()
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertTrue(pagerContent.isInifinitePager)
    }

    func test_GivenPager_WhenLoopPagesRepeating3_ThenDataArrayIsLarger() {
        var pager = givenPager
        pager = pager.loopPages(repeating: 3)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertTrue(pagerContent.isInifinitePager)
        XCTAssertEqual(pagerContent.data.count, 60)
    }

    func test_GivenPager_WhenDisableDragging_ThenAllowsDraggingFalse() {
        var pager = givenPager
        pager = pager.disableDragging()
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertFalse(pagerContent.allowsDragging)
    }

    func test_GivenPager_WhenAllowsDragging_ThenAllowsDraggingTrue() {
        var pager = givenPager
        pager = pager.allowsDragging()
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertTrue(pagerContent.allowsDragging)
    }

    func test_GivenPager_WhenAllowsDraggingFalse_ThenAllowsDraggingFalse() {
        var pager = givenPager
        pager = pager.allowsDragging(false)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertFalse(pagerContent.allowsDragging)
    }

    func test_GivenPager_WhenSwipeInteractionAreaAllAvailable_ThenAllAvailable() {
        var pager = givenPager
        pager = pager.swipeInteractionArea(.allAvailable)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.swipeInteractionArea, .allAvailable)
    }

    func test_GivenAllnteractionAreaPager_WhenSwipeInteractionAreaPage_ThenPage() {
        var pager = givenPager.swipeInteractionArea(.allAvailable)
        pager = pager.swipeInteractionArea(.page)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.swipeInteractionArea, .page)
    }

    func test_GivenPager_WhenVertical_ThenIsVerticalTrue() {
        var pager = givenPager
        pager = pager.vertical()
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertTrue(pagerContent.isVertical)
        XCTAssertEqual(pagerContent.scrollDirectionAngle, .zero)
    }
    
    func test_GivenVerticalPager_WhenHorizontal_ThenIsHorizontalTrue() {
        var pager = givenPager.vertical()
        pager = pager.horizontal()
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertTrue(pagerContent.isHorizontal)
    }
    
    func test_GivenPager_WhenInteractiveLessThanZero_ThenNotSet() {
        let pager = givenPager
        let pagerInteractive = pager.interactive(-0.7)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        let pagerContentInteractive = pagerInteractive.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.interactiveScale, pagerContentInteractive.interactiveScale)
    }
    
    func test_GivenPager_WhenInteractiveGreaterThanOne_ThenNotSet() {
        let pager = givenPager
        let pagerInteractive = pager.interactive(1.5)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        let pagerContentInteractive = pagerInteractive.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.interactiveScale, pagerContentInteractive.interactiveScale)
    }
    
    func test_GivenPager_WhenInteractive_ThenInteractiveScaleIs() {
        var pager = givenPager
        pager = pager.interactive(0.7)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.interactiveScale, 0.7)
    }
    
    func test_GivenPagerWith3DRotation_WhenInteractive_ThenInteractiveScaleNotChanged() {
        let pagerWithRotation = givenPager.rotation3D()
        let pagerInteractive = pagerWithRotation.interactive(0.8)
        let pagerContentWithRotation = pagerWithRotation.content(for: CGSize(width: 100, height: 100))
        let pagerContentInteractive = pagerInteractive.content(for: CGSize(width: 100, height: 100))

        XCTAssertEqual(pagerContentInteractive.interactiveScale, pagerContentWithRotation.interactiveScale)
        XCTAssertEqual(pagerContentInteractive.shouldRotate, pagerContentWithRotation.shouldRotate)
    }

    func test_GivenPager_WhenCombineInteractiveModifier_ThenNoExclusive() {
        let interactivePager = givenPager
            .interactive(scale: 0.4)
            .interactive(opacity: 0.3)
            .interactive(rotation: true)
        let pagerContent = interactivePager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.opacityIncrement, 0.3)
        XCTAssertEqual(pagerContent.interactiveScale, 0.4)
        XCTAssertTrue(pagerContent.shouldRotate)
    }
    
    func test_GivenPager_When3DRotation_ThenShouldRotate() {
        var pager = givenPager
        pager = pager.rotation3D()
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))

        XCTAssertTrue(pagerContent.shouldRotate)
        XCTAssertEqual(pagerContent.interactiveScale, 0.7)
    }
    
    func test_GivenPagerWith3DRotation_When3DRotationFalse_ThenShouldRotateFalse() {
        var pager = givenPager.rotation3D()
        pager = pager.rotation3D(false)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))

        XCTAssertFalse(pagerContent.shouldRotate)
        XCTAssertEqual(pagerContent.interactiveScale, 1)
    }
    
    func test_GivenPager_WhenHorizontalRightToLeft_ThenScrollAngle() {
        var pager = givenPager.vertical()
        pager = pager.horizontal(.rightToLeft)

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertTrue(pagerContent.isHorizontal)
        XCTAssertEqual(pagerContent.scrollDirectionAngle, Angle(degrees: 180))
    }

    func test_GivenPager_WhenAlignment_ThenAlignmentSet() {
        var pager = givenPager
        pager = pager.alignment(.end(10))
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.alignment, .end(10))
    }

    func test_GivenPager_WhenVerticalBottomToTop_ThenScrollAngle() {
        var pager = givenPager
        pager = pager.vertical(.bottomToTop)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertTrue(pagerContent.isVertical)
        XCTAssertEqual(pagerContent.scrollDirectionAngle, Angle(degrees: 180))
    }
    
    func test_GivenPager_WhenPageOffset_ThenPageOffset() {
        var pager = givenPager
        pager = pager.pageOffset(50)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.pageOffset, 50)
    }

    func test_GivenPager_WhenPageOffsetPositive_ThenDirectionForward() throws {
        var pager = givenPager
        pager = pager.pageOffset(50)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.pageOffset, 50)

        let direction = try XCTUnwrap(pagerContent.direction)
        XCTAssertEqual(direction, .forward)
        XCTAssertTrue(pagerContent.isDragging)
    }

    func test_GivenPager_WhenPageOffsetNegative_ThenDirectionBackward() throws {
        var pager = givenPager
        pager = pager.pageOffset(-50)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.pageOffset, -50)

        let direction = try XCTUnwrap(pagerContent.direction)
        XCTAssertEqual(direction, .backward)
        XCTAssertTrue(pagerContent.isDragging)
    }
    
    func test_GivenPager_WhenItemSpacing_ThenItemSpacing() {
        var pager = givenPager
        pager = pager.itemSpacing(30)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.itemSpacing, 30)
    }
    
    func test_GivenPager_WhenItemAspectRatioNotNil_ThenSetItemAspectRatio() {
        var pager = givenPager.preferredItemSize(CGSize(width: 50, height: 50))
        pager = pager.itemAspectRatio(1.2, alignment: .start(10))
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.itemAspectRatio, 1.2)
        XCTAssertNil(pagerContent.preferredItemSize)
        XCTAssertTrue(pagerContent.itemAlignment.equalsIgnoreValues(.start))
    }

    func test_GivenPager_WhenItemAspectAlignmentEnd_ThenItemAlignmentEnd() {
        var pager = givenPager
        pager = pager.itemAspectRatio(1, alignment: .end)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertTrue(pagerContent.itemAlignment.equalsIgnoreValues(.end))
    }

    func test_GivenPager_WhenItemAspectAlignmentStart_ThenItemAlignmentStart() {
        var pager = givenPager
        pager = pager.itemAspectRatio(1, alignment: .start(10))
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertTrue(pagerContent.itemAlignment.equalsIgnoreValues(.start))
    }
    
    func test_GivenPager_WhenItemAspectRatioLessThanZero_ThenDoNotSetItemAspectRatio() {
        var pager = givenPager
        pager = pager.itemAspectRatio(-1.2)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertNil(pagerContent.itemAspectRatio)
    }
    
    func test_GivenPagerWithItemAspectRatio_WhenItemAspectRatioNil_ThenSetNil() {
        var pager = givenPager.itemAspectRatio(1.2)
        pager = pager.itemAspectRatio(nil)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertNil(pagerContent.itemAspectRatio)
    }
    
    func test_GivenPagerWithItemAspectRatio_WhenExpandPageToEdges_ThenItemAspectRatioNil() {
        var pager = givenPager.itemAspectRatio(1.2)
        pager = pager.expandPageToEdges()
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertNil(pagerContent.itemAspectRatio)
    }

    func test_GivenPagerWithPreferredPageSize_WhenPadding_ThenNoInsets() {
        var pager = givenPager.preferredItemSize(CGSize(width: 50, height: 50))
        pager = pager.padding(8)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.sideInsets, 0)
    }
    
    func test_GivenHorizontalPager_WhenPaddingHorizontal_ThenNoInsets() {
        var pager = givenPager
        pager = pager.padding(.horizontal, 8)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.sideInsets, 0)
    }
    
    func test_GivenVerticalPager_WhenPaddingVertical_ThenNoInsets() {
        var pager = givenPager.vertical()
        pager = pager.padding(.vertical, 8)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.sideInsets, 0)
    }
    
    func test_GivenHorizontalPager_WhenPaddingVertical_ThenSideInsets() {
        var pager = givenPager
        pager = pager.padding(.vertical, 8)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.sideInsets, 8)
    }
    
    func test_GivenVerticalPager_WhenPaddingHorizontal_ThenSideInsets() {
        var pager = givenPager.vertical()
        pager = pager.padding(.horizontal, 8)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.sideInsets, 8)
    }
    
    func test_GivenHorizontalPager_WhenPaddingVertical_ThenMinTopAndBottom() {
        var pager = givenPager
        pager = pager.padding(EdgeInsets(top: 10, leading: 5, bottom: 15, trailing: 2))
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.sideInsets, 10)
    }
    
    func test_GivenVerticalPager_WhenPaddingHorizontal_ThenMinLeadingAndTrailing() {
        var pager = givenPager.vertical()
        pager = pager.padding(EdgeInsets(top: 10, leading: 5, bottom: 15, trailing: 2))
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.sideInsets, 2)
    }
    
    func test_GivenHorizontalPager_WhenPaddingVertical_ThenDefaultInsets() {
        var pager = givenPager
        pager = pager.padding(.vertical)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.sideInsets, 8)
    }
    
    func test_GivenHorizontalPager_WhenPadding_ThenDefaultLengthVerticalInsets() {
        var pager = givenPager
        pager = pager.padding(5)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.sideInsets, 5)
    }

    func test_GivenPager_WhenOnDraggingBegan_ThenCallback() {
        var pager = givenPager
        let expectation = self.expectation(description: "Callback is called")
        pager = pager.onDraggingBegan({
            expectation.fulfill()
        })

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        pagerContent.onDragChanged(with: DragGesture.Value.unsafeInit())
        waitForExpectations(timeout: 1, handler: nil)
    }

    func test_GivenPager_WhenOnDraggingChanged_ThenCallback() {
        var pager = givenPager
        pager = pager.onDraggingChanged({ _ in })
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertNotNil(pagerContent.onDraggingChanged)
    }

    func test_GivenPager_WhenOnDraggingEnded_ThenCallback() {
        var pager = givenPager
        let expectation = self.expectation(description: "Callback is called")
        pager = pager.onDraggingEnded({
            expectation.fulfill()
        })

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        pagerContent.onDragGestureEnded()
        waitForExpectations(timeout: 1, handler: nil)
    }

    func test_GivenPager_WhenBouncesFalse_ThenBouncesFalse() {
        let pager = givenPager.bounces(false)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertFalse(pagerContent.bounces)
    }

    func test_GivenPager_WhenOnPageChanged_ThenCallbackNotNil() {
        let pager = givenPager.onPageChanged { _ in }
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertNotNil(pagerContent.onPageChanged)
    }

    func test_GivenPager_WhenOnPageWillTransition_ThenSuccessfulTransition() throws {
        var pager = givenPager

        var transition: PageTransition? = nil
        pager = pager.onPageWillTransition({ (result) in
            transition = try? result.get()
        })

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        let initialPage = pagerContent.page
        pager.pagerModel.draggingOffset = -pagerContent.pageSize.width
        pagerContent.onDragGestureEnded()

        let transitionUnwrapped = try XCTUnwrap(transition)
        XCTAssertEqual(pagerContent.page, transitionUnwrapped.nextPage)
        XCTAssertEqual(initialPage, transitionUnwrapped.currentPage)
        XCTAssertEqual(transitionUnwrapped.pageIncrement, 1)
    }

    func test_GivenPager_WhenOnPageWillTransition_ThenFailedTransition() throws {
        var pager = givenPager

        var error: PageTransitionError? = nil
        pager = pager.onPageWillTransition({ (result) in
            guard case .failure (let transitionError) = result else { return }
            error = transitionError
        })

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        pager.pagerModel.draggingOffset = -pagerContent.pageSize.width / 10
        pagerContent.onDragGestureEnded()

        XCTAssertEqual(error, .draggingStopped)
    }

    func test_GivenPager_WhenOnPageWillChange_ThenObservePageChanges() throws {
        var pager = givenPager
        
        var newPage: Int? = nil
        pager = pager.onPageWillChange({ (page) in
            newPage = page
        })
        
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        pager.pagerModel.draggingOffset = -pagerContent.pageSize.width
        pagerContent.onDragGestureEnded()

        let newPageUnwrapped = try XCTUnwrap(newPage)
        XCTAssertEqual(pagerContent.page, newPageUnwrapped)
    }

    func test_GivenPager_WhenOnPageWillChange_ThenObserveNoPageChanges() throws {
        var pager = givenPager

        var newPage: Int? = nil
        pager = pager.onPageWillChange({ (page) in
            newPage = page
        })

        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        pager.pagerModel.draggingOffset = -pagerContent.pageSize.width / 4
        pagerContent.onDragGestureEnded()

        XCTAssertNil(newPage)
        XCTAssertEqual(pagerContent.page, 0)
    }

    func test_GivenPagerWithSizeZero_WhenPageSize_ThenZero() {
        let pager = givenPager
        let pagerContent = pager.content(for: .zero)
        XCTAssertEqual(pagerContent.pageSize, .zero)
        XCTAssertEqual(pagerContent.maximumNumberOfPages, 0)
    }

    func test_GivenPager_WhenPreferredItemSize_ThenPageSizeIsPreferredSize() {
        var pager = givenPager
        pager = pager.preferredItemSize(CGSize(width: 50, height: 50))
        let pagerContent = pager.content(for: CGSize(width: 150, height: 150))
        XCTAssertEqual(pagerContent.pageSize, CGSize(width: 50, height: 50))
    }

    func test_GivenPager_WhenPreferredItemSize_ThenPageSizeIsTrimmed() {
        var pager = givenPager
        pager = pager.preferredItemSize(CGSize(width: 50, height: 50))
        let pagerContent = pager.content(for: CGSize(width: 40, height: 40))
        XCTAssertEqual(pagerContent.pageSize, CGSize(width: 40, height: 40))
    }

    func test_GivenPager_WhenPadding_ThenPageSizeIsInset() {
        var pager = givenPager
        pager = pager.padding(10)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.pageSize, CGSize(width: 80, height: 80))
    }

    func test_GivenPager_WhenItemAspectRatioGreatherThanOne_ThenExpectedPageSize() {
        var pager = givenPager
        pager = pager
            .padding(10)
            .itemAspectRatio(1.2)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 200))
        XCTAssertEqual(pagerContent.pageSize.width, 80)
        XCTAssertEqual(pagerContent.pageSize.height.rounded(), (80 / 1.2).rounded())
    }

    func test_GivenPager_WhenItemAspectRatioLessThanOne_ThenExpectedPageSize() {
        var pager = givenPager
        pager = pager
            .padding(10)
            .itemAspectRatio(0.7)
        let pagerContent = pager.content(for: CGSize(width: 300, height: 200))
        XCTAssertEqual(pagerContent.pageSize.height, 180)
        XCTAssertEqual(pagerContent.pageSize.width.rounded(), (180 * 0.7).rounded())
    }

    func test_GivenPager_WhenItemInteractiveItemSpacing_ThenItemSpacing() {
        let pager = givenPager
            .itemSpacing(10)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 200))
        XCTAssertEqual(pagerContent.interactiveItemSpacing, 10)
    }

    static var allTests = [
        ("test_GivenPager_WhenItemInteractiveItemSpacing_ThenItemSpacing", test_GivenPager_WhenItemInteractiveItemSpacing_ThenItemSpacing),
        ("test_GivenPager_WhenItemAspectRatioLessThanOne_ThenExpectedPageSize", test_GivenPager_WhenItemAspectRatioLessThanOne_ThenExpectedPageSize),
        ("test_GivenPager_WhenItemAspectRatioGreatherThanOne_ThenExpectedPageSize", test_GivenPager_WhenItemAspectRatioGreatherThanOne_ThenExpectedPageSize),
        ("test_GivenPager_WhenPadding_ThenPageSizeIsInset", test_GivenPager_WhenPadding_ThenPageSizeIsInset),
        ("test_GivenPager_WhenPreferredItemSize_ThenPageSizeIsTrimmed", test_GivenPager_WhenPreferredItemSize_ThenPageSizeIsTrimmed),
        ("test_GivenPager_WhenPreferredItemSize_ThenPageSizeIsPreferredSize", test_GivenPager_WhenPreferredItemSize_ThenPageSizeIsPreferredSize),
        ("test_GivenPagerWithSizeZero_WhenPageSize_ThenZero", test_GivenPagerWithSizeZero_WhenPageSize_ThenZero),
        ("test_GivenPager_ThenDefaultValues", test_GivenPager_ThenDefaultValues),
        ("test_GivenPager_WhenVertical_ThenIsVerticalTrue", test_GivenPager_WhenVertical_ThenIsVerticalTrue),
        ("test_GivenVerticalPager_WhenHorizontal_ThenIsHorizontalTrue", test_GivenVerticalPager_WhenHorizontal_ThenIsHorizontalTrue),
        ("test_GivenPager_WhenInteractiveLessThanZero_ThenNotSet", test_GivenPager_WhenInteractiveLessThanZero_ThenNotSet),
        ("test_GivenPager_WhenInteractiveGreaterThanOne_ThenNotSet", test_GivenPager_WhenInteractiveGreaterThanOne_ThenNotSet),
        ("test_GivenPager_WhenInteractive_ThenInteractiveScaleIs", test_GivenPager_WhenInteractive_ThenInteractiveScaleIs),
        ("test_GivenPagerWith3DRotation_WhenInteractive_ThenInteractiveScaleNotChanged", test_GivenPagerWith3DRotation_WhenInteractive_ThenInteractiveScaleNotChanged),
        ("test_GivenPager_When3DRotation_ThenShouldRotate", test_GivenPager_When3DRotation_ThenShouldRotate),
        ("test_GivenPagerWith3DRotation_When3DRotationFalse_ThenShouldRotateFalse", test_GivenPagerWith3DRotation_When3DRotationFalse_ThenShouldRotateFalse),
        ("test_GivenPager_WhenDraggingAnimation_ThenDraggingAndPagingAnimationNotNil", test_GivenPager_WhenDraggingAnimation_ThenDraggingAndPagingAnimationNotNil),
        ("test_GivenPager_WhenDraggingAnimation_ThenDraggingAnimationNotNil", test_GivenPager_WhenDraggingAnimation_ThenDraggingAnimationNotNil),
        ("test_GivenPager_WhenHorizontalRightToLeft_ThenScrollAngle", test_GivenPager_WhenHorizontalRightToLeft_ThenScrollAngle),
        ("test_GivenPager_WhenAlignment_ThenAlignmentSet", test_GivenPager_WhenAlignment_ThenAlignmentSet),
        ("test_GivenPager_WhenVerticalBottomToTop_ThenScrollAngle", test_GivenPager_WhenVerticalBottomToTop_ThenScrollAngle),
        ("test_GivenPager_WhenPageOffset_ThenPageOffset", test_GivenPager_WhenPageOffset_ThenPageOffset),
        ("test_GivenPager_WhenItemSpacing_ThenItemSpacing", test_GivenPager_WhenItemSpacing_ThenItemSpacing),
        ("test_GivenPager_WhenItemAspectRatioNotNil_ThenSetItemAspectRatio", test_GivenPager_WhenItemAspectRatioNotNil_ThenSetItemAspectRatio),
        ("test_GivenPager_WhenItemAspectRatioLessThanZero_ThenDoNotSetItemAspectRatio", test_GivenPager_WhenItemAspectRatioLessThanZero_ThenDoNotSetItemAspectRatio),
        ("test_GivenPagerWithItemAspectRatio_WhenItemAspectRatioNil_ThenSetNil", test_GivenPagerWithItemAspectRatio_WhenItemAspectRatioNil_ThenSetNil),
        ("test_GivenPagerWithItemAspectRatio_WhenExpandPageToEdges_ThenItemAspectRatioNil", test_GivenPagerWithItemAspectRatio_WhenExpandPageToEdges_ThenItemAspectRatioNil),
        ("test_GivenHorizontalPager_WhenPaddingHorizontal_ThenNoInsets", test_GivenHorizontalPager_WhenPaddingHorizontal_ThenNoInsets),
        ("test_GivenVerticalPager_WhenPaddingVertical_ThenNoInsets", test_GivenVerticalPager_WhenPaddingVertical_ThenNoInsets),
        ("test_GivenHorizontalPager_WhenPaddingVertical_ThenSideInsets", test_GivenHorizontalPager_WhenPaddingVertical_ThenSideInsets),
        ("test_GivenHorizontalPager_WhenPaddingVertical_ThenMinTopAndBottom", test_GivenHorizontalPager_WhenPaddingVertical_ThenMinTopAndBottom),
        ("test_GivenVerticalPager_WhenPaddingHorizontal_ThenMinLeadingAndTrailing", test_GivenVerticalPager_WhenPaddingHorizontal_ThenMinLeadingAndTrailing),
        ("test_GivenHorizontalPager_WhenPaddingVertical_ThenDefaultInsets", test_GivenHorizontalPager_WhenPaddingVertical_ThenDefaultInsets),
        ("test_GivenHorizontalPager_WhenPadding_ThenDefaultLengthVerticalInsets", test_GivenHorizontalPager_WhenPadding_ThenDefaultLengthVerticalInsets),
        ("test_GivenPager_WhenOnPageWillChange_ThenObservePageChanges", test_GivenPager_WhenOnPageWillChange_ThenObservePageChanges),
        ("test_GivenPager_WhenOnPageWillChange_ThenObserveNoPageChanges", test_GivenPager_WhenOnPageWillChange_ThenObserveNoPageChanges),
        ("test_GivenPager_WhenSwipeInteractionAreaAllAvailable_ThenAllAvailable", test_GivenPager_WhenSwipeInteractionAreaAllAvailable_ThenAllAvailable),
        ("test_GivenAllnteractionAreaPager_WhenSwipeInteractionAreaPage_ThenPage", test_GivenAllnteractionAreaPager_WhenSwipeInteractionAreaPage_ThenPage),
        ("test_GivenPager_WhenItemAspectAlignmentEnd_ThenItemAlignmentEnd", test_GivenPager_WhenItemAspectAlignmentEnd_ThenItemAlignmentEnd),
        ("test_GivenPager_WhenItemAspectAlignmentStart_ThenItemAlignmentStart", test_GivenPager_WhenItemAspectAlignmentStart_ThenItemAlignmentStart),
        ("test_GivenPager_WhenDisableDragging_ThenAllowsDraggingFalse", test_GivenPager_WhenDisableDragging_ThenAllowsDraggingFalse),
        ("test_GivenPager_WhenAllowsDragging_ThenAllowsDraggingTrue", test_GivenPager_WhenAllowsDragging_ThenAllowsDraggingTrue),
        ("test_GivenPager_WhenAllowsDraggingFalse_ThenAllowsDraggingFalse", test_GivenPager_WhenAllowsDraggingFalse_ThenAllowsDraggingFalse),
        ("test_GivenPager_WhenLoopPages_ThenIsInfinitePagerTrue", test_GivenPager_WhenLoopPages_ThenIsInfinitePagerTrue),
        ("test_GivenPager_WhenPreferredItemSize_ThenNotNil", test_GivenPager_WhenPreferredItemSize_ThenNotNil),
        ("test_GivenPager_WhenPagingPrioritySimultaneous_ThenSimultaneous", test_GivenPager_WhenPagingPrioritySimultaneous_ThenSimultaneous),
        ("test_GivenPager_WhenPagingPriorityHigh_ThenHigh", test_GivenPager_WhenPagingPriorityHigh_ThenHigh),
        ("test_GivenPager_WhenContentLoadingPolicyLazy0_ThenRecyclingRatioIs1", test_GivenPager_WhenContentLoadingPolicyLazy0_ThenRecyclingRatioIs1),
        ("test_GivenPager_WhenContentLoadingPolicyLazy10_ThenRecyclingRatioIs10", test_GivenPager_WhenContentLoadingPolicyLazy10_ThenRecyclingRatioIs10),
        ("test_GivenPager_WhenContentLoadingPolicyEager_ThenRecyclingRatioIsIntMax", test_GivenPager_WhenContentLoadingPolicyEager_ThenRecyclingRatioIsIntMax),
        ("test_GivenPager_WhenLoopPagesRepeating3_ThenDataArrayIsLarger", test_GivenPager_WhenLoopPagesRepeating3_ThenDataArrayIsLarger),
        ("test_GivenPager_WhenMultiplePagination_ThenAllowsMultiplePagination", test_GivenPager_WhenMultiplePagination_ThenAllowsMultiplePagination),
        ("test_GivenPager_WhenPagingAnimation_ThenPagingAnimationNotNil", test_GivenPager_WhenPagingAnimation_ThenPagingAnimationNotNil),
        ("test_GivenPager_WhenPageOffsetPositive_ThenDirectionForward", test_GivenPager_WhenPageOffsetPositive_ThenDirectionForward),
        ("test_GivenPager_WhenPageOffsetNegative_ThenDirectionBackward", test_GivenPager_WhenPageOffsetNegative_ThenDirectionBackward),
        ("test_GivenPager_WhenSinglePagination_ThenRatioChanges", test_GivenPager_WhenSinglePagination_ThenRatioChanges),
        ("test_GivenPager_WhenSinglePaginationNegativeValue_ThenRatioZero", test_GivenPager_WhenSinglePaginationNegativeValue_ThenRatioZero),
        ("test_GivenPager_WhenSinglePaginationTooLarge_ThenRatio1", test_GivenPager_WhenSinglePaginationTooLarge_ThenRatio1),
        ("test_GivenMultiplePaginationPager_WhenSinglePagination_ThenAllowsMultiplePaginationFalse", test_GivenMultiplePaginationPager_WhenSinglePagination_ThenAllowsMultiplePaginationFalse),
        ("test_GivenPager_WhenBouncesFalse_ThenBouncesFalse", test_GivenPager_WhenBouncesFalse_ThenBouncesFalse),
        ("test_GivenPager_WhenOnDraggingBegan_ThenCallback", test_GivenPager_WhenOnDraggingBegan_ThenCallback),
        ("test_GivenPager_WhenOnDraggingChanged_ThenCallback", test_GivenPager_WhenOnDraggingChanged_ThenCallback),
        ("test_GivenPager_WhenOnDraggingEnded_ThenCallback", test_GivenPager_WhenOnDraggingEnded_ThenCallback),
        ("test_GivenPager_WhenOnPageChanged_ThenCallbackNotNil", test_GivenPager_WhenOnPageChanged_ThenCallbackNotNil),
        ("test_GivenPager_WhenFaded_ThenOpacityIncrementChanges", test_GivenPager_WhenFaded_ThenOpacityIncrementChanges),
        ("test_GivenPager_WhenCombineInteractiveModifier_ThenNoExclusive", test_GivenPager_WhenCombineInteractiveModifier_ThenNoExclusive),
        ("test_GivenPager_WhenCombineInteractiveModifier_ThenNoExclusive", test_GivenPager_WhenCombineInteractiveModifier_ThenNoExclusive),
        ("test_GivenPager_WhenOnPageWillTransition_ThenFailedTransition", test_GivenPager_WhenOnPageWillTransition_ThenFailedTransition),
        ("test_GivenPager_WhenOnPageWillTransition_ThenSuccessfulTransition", test_GivenPager_WhenOnPageWillTransition_ThenSuccessfulTransition)
    ]
}

extension DragGesture.Value {
    struct Dummy {
        let data: (Double, Double, Double,
                   Double, Double, Double, Double) = (0, 0, 0, 0, 0, 0, 0)
    }

    static func unsafeInit() -> Self {
//        let byteCount = MemoryLayout<DragGesture.Value>.size
        return unsafeBitCast(Dummy(), to: DragGesture.Value.self)
    }

}
