import XCTest
import SwiftUI
@testable import SwiftUIPager

final class Pager_Buildable_Tests: XCTestCase {

    var givenPager: Pager<Int, Int, Text> {
        Pager(page: .constant(0), data: Array(1..<20), id: \.self) {
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
        XCTAssertEqual(pager.minimumDistance, 15)
        XCTAssertEqual(pager.gesturePriority, .default)
        XCTAssertEqual(pager.contentLoadingPolicy, .default)
        XCTAssertEqual(pager.allowsMultiplePagination, false)
        XCTAssertNil(pager.pagingAnimation)
    }

    func test_GivenPager_WhenPagingAnimation_ThenPagingAnimationNotNil() throws {
        var pager = givenPager
        pager = pager.pagingAnimation({ _ in .steep })
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        let pagingAnimation = try XCTUnwrap(pagerContent.pagingAnimation?((0, 0, 0, 0)))
        XCTAssertEqual(pagingAnimation, PagingAnimation.steep)
    }

    func test_GivenPager_WhenMultiplePagination_ThenAllowsMultiplePagination() {
        var pager = givenPager
        pager = pager.multiplePagination()
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertTrue(pagerContent.allowsMultiplePagination)
        XCTAssertEqual(pagerContent.contentLoadingPolicy, .eager)
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
        XCTAssertGreaterThan(pagerContent.data.count, 20)
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
    
    func test_GivenPager_WhenInteractiveLesserThanZero_ThenNotSet() {
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
    
    func test_GivenPager_When3DRotation_ThenShouldRotate() {
        var pager = givenPager
        pager = pager.rotation3D()
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))

        XCTAssertTrue(pagerContent.shouldRotate)
        XCTAssertEqual(pagerContent.interactiveScale, pagerContent.rotationInteractiveScale)
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
        pager = pager.pageOffset(1.2)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pagerContent.pageOffset, 1.2)
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
    
    func test_GivenPager_WhenItemAspectRatioLesserThanZero_ThenDoNotSetItemAspectRatio() {
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

    
    func test_GivenPager_WhenOnPageChanged_ThenObservePageChanges() throws {
        var pager = givenPager
        
        var newPage: Int? = nil
        pager = pager.onPageChanged({ (page) in
            newPage = page
        })

        pager.page = 3

        let newPageUnwrapped = try XCTUnwrap(newPage)
        let pagerContent = pager.content(for: CGSize(width: 100, height: 100))
        XCTAssertEqual(pager.page, newPageUnwrapped)
        XCTAssertEqual(pagerContent.page, pager.page)
    }

    static var allTests = [
        ("test_GivenPager_ThenDefaultValues", test_GivenPager_ThenDefaultValues),
        ("test_GivenPager_WhenVertical_ThenIsVerticalTrue", test_GivenPager_WhenVertical_ThenIsVerticalTrue),
        ("test_GivenVerticalPager_WhenHorizontal_ThenIsHorizontalTrue", test_GivenVerticalPager_WhenHorizontal_ThenIsHorizontalTrue),
        ("test_GivenPager_WhenInteractiveLesserThanZero_ThenNotSet", test_GivenPager_WhenInteractiveLesserThanZero_ThenNotSet),
        ("test_GivenPager_WhenInteractiveGreaterThanOne_ThenNotSet", test_GivenPager_WhenInteractiveGreaterThanOne_ThenNotSet),
        ("test_GivenPager_WhenInteractive_ThenInteractiveScaleIs", test_GivenPager_WhenInteractive_ThenInteractiveScaleIs),
        ("test_GivenPagerWith3DRotation_WhenInteractive_ThenInteractiveScaleNotChanged", test_GivenPagerWith3DRotation_WhenInteractive_ThenInteractiveScaleNotChanged),
        ("test_GivenPager_When3DRotation_ThenShouldRotate", test_GivenPager_When3DRotation_ThenShouldRotate),
        ("test_GivenPagerWith3DRotation_When3DRotationFalse_ThenShouldRotateFalse", test_GivenPagerWith3DRotation_When3DRotationFalse_ThenShouldRotateFalse),
        ("test_GivenPager_WhenHorizontalRightToLeft_ThenScrollAngle", test_GivenPager_WhenHorizontalRightToLeft_ThenScrollAngle),
        ("test_GivenPager_WhenAlignment_ThenAlignmentSet", test_GivenPager_WhenAlignment_ThenAlignmentSet),
        ("test_GivenPager_WhenVerticalBottomToTop_ThenScrollAngle", test_GivenPager_WhenVerticalBottomToTop_ThenScrollAngle),
        ("test_GivenPager_WhenPageOffset_ThenPageOffset", test_GivenPager_WhenPageOffset_ThenPageOffset),
        ("test_GivenPager_WhenItemSpacing_ThenItemSpacing", test_GivenPager_WhenItemSpacing_ThenItemSpacing),
        ("test_GivenPager_WhenItemAspectRatioNotNil_ThenSetItemAspectRatio", test_GivenPager_WhenItemAspectRatioNotNil_ThenSetItemAspectRatio),
        ("test_GivenPager_WhenItemAspectRatioLesserThanZero_ThenDoNotSetItemAspectRatio", test_GivenPager_WhenItemAspectRatioLesserThanZero_ThenDoNotSetItemAspectRatio),
        ("test_GivenPagerWithItemAspectRatio_WhenItemAspectRatioNil_ThenSetNil", test_GivenPagerWithItemAspectRatio_WhenItemAspectRatioNil_ThenSetNil),
        ("test_GivenPagerWithItemAspectRatio_WhenExpandPageToEdges_ThenItemAspectRatioNil", test_GivenPagerWithItemAspectRatio_WhenExpandPageToEdges_ThenItemAspectRatioNil),
        ("test_GivenHorizontalPager_WhenPaddingHorizontal_ThenNoInsets", test_GivenHorizontalPager_WhenPaddingHorizontal_ThenNoInsets),
        ("test_GivenVerticalPager_WhenPaddingVertical_ThenNoInsets", test_GivenVerticalPager_WhenPaddingVertical_ThenNoInsets),
        ("test_GivenHorizontalPager_WhenPaddingVertical_ThenSideInsets", test_GivenHorizontalPager_WhenPaddingVertical_ThenSideInsets),
        ("test_GivenHorizontalPager_WhenPaddingVertical_ThenMinTopAndBottom", test_GivenHorizontalPager_WhenPaddingVertical_ThenMinTopAndBottom),
        ("test_GivenVerticalPager_WhenPaddingHorizontal_ThenMinLeadingAndTrailing", test_GivenVerticalPager_WhenPaddingHorizontal_ThenMinLeadingAndTrailing),
        ("test_GivenHorizontalPager_WhenPaddingVertical_ThenDefaultInsets", test_GivenHorizontalPager_WhenPaddingVertical_ThenDefaultInsets),
        ("test_GivenHorizontalPager_WhenPadding_ThenDefaultLengthVerticalInsets", test_GivenHorizontalPager_WhenPadding_ThenDefaultLengthVerticalInsets),
        ("test_GivenPager_WhenOnPageChanged_ThenObservePageChanges", test_GivenPager_WhenOnPageChanged_ThenObservePageChanges),
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
        ("test_GivenPager_WhenPagingAnimation_ThenPagingAnimationNotNil", test_GivenPager_WhenPagingAnimation_ThenPagingAnimationNotNil)
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
