import XCTest
import SwiftUI
@testable import SwiftUIPager

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
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
        XCTAssertEqual(pager.scrollDirectionAngle, .zero)
        XCTAssertEqual(pager.interactiveScale, 1)
        XCTAssertEqual(pager.alignment, .center)
        XCTAssertFalse(pager.shouldRotate)
        XCTAssertEqual(pager.pageOffset, 0)
        XCTAssertEqual(pager.sideInsets, 0)
        XCTAssertEqual(pager.itemSpacing, 0)
        XCTAssertEqual(pager.itemAlignment, .center)
        XCTAssertEqual(pager.swipeInteractionArea, .page)
        XCTAssertEqual(pager.minimumDistance, 15)
    }

    func test_GivenPager_WhenLoopPages_ThenIsInfinitePagerTrue() {
        var pager = givenPager
        pager = pager.loopPages()
        XCTAssertTrue(pager.isInifinitePager)
    }

    func test_GivenPager_WhenHighPriorityGesture_ThenMinimumDistanceZero() {
        var pager = givenPager
        pager = pager.highPriorityGesture()
        XCTAssertEqual(pager.minimumDistance, 0)
    }

    func test_GivenPager_WhenDisableDragging_ThenAllowsDraggingFalse() {
        var pager = givenPager
        pager = pager.disableDragging()
        XCTAssertFalse(pager.allowsDragging)
    }

    func test_GivenPager_WhenAllowsDragging_ThenAllowsDraggingTrue() {
        var pager = givenPager
        pager = pager.allowsDragging()
        XCTAssertTrue(pager.allowsDragging)
    }

    func test_GivenPager_WhenAllowsDraggingFalse_ThenAllowsDraggingFalse() {
        var pager = givenPager
        pager = pager.allowsDragging(false)
        XCTAssertFalse(pager.allowsDragging)
    }

    func test_GivenPager_WhenSwipeInteractionAreaAllAvailable_ThenAllAvailable() {
        var pager = givenPager
        pager = pager.swipeInteractionArea(.allAvailable)
        XCTAssertEqual(pager.swipeInteractionArea, .allAvailable)
    }

    func test_GivenAllnteractionAreaPager_WhenSwipeInteractionAreaPage_ThenPage() {
        var pager = givenPager.swipeInteractionArea(.allAvailable)
        pager = pager.swipeInteractionArea(.page)
        XCTAssertEqual(pager.swipeInteractionArea, .page)
    }

    func test_GivenPager_WhenVertical_ThenIsVerticalTrue() {
        var pager = givenPager
        pager = pager.vertical()
        XCTAssertTrue(pager.isVertical)
        XCTAssertEqual(pager.scrollDirectionAngle, .zero)
    }
    
    func test_GivenVerticalPager_WhenHorizontal_ThenIsHorizontalTrue() {
        var pager = givenPager.vertical()
        pager = pager.horizontal()
        XCTAssertTrue(pager.isHorizontal)
    }
    
    func test_GivenPager_WhenInteractiveLesserThanZero_ThenNotSet() {
        let pager = givenPager
        let pagerInteractive = pager.interactive(-0.7)
        XCTAssertEqual(pager.interactiveScale, pagerInteractive.interactiveScale)
    }
    
    func test_GivenPager_WhenInteractiveGreaterThanOne_ThenNotSet() {
        let pager = givenPager
        let pagerInteractive = pager.interactive(1.5)
        XCTAssertEqual(pager.interactiveScale, pagerInteractive.interactiveScale)
    }
    
    func test_GivenPager_WhenInteractive_ThenInteractiveScaleIs() {
        var pager = givenPager
        pager = pager.interactive(0.7)
        XCTAssertEqual(pager.interactiveScale, 0.7)
    }
    
    func test_GivenPagerWith3DRotation_WhenInteractive_ThenInteractiveScaleNotChanged() {
        let pagerWithRotation = givenPager.rotation3D()
        let pagerInteractive = pagerWithRotation.interactive(0.8)
        XCTAssertEqual(pagerInteractive.interactiveScale, pagerWithRotation.interactiveScale)
        XCTAssertEqual(pagerInteractive.shouldRotate, pagerWithRotation.shouldRotate)
    }
    
    func test_GivenPager_When3DRotation_ThenShouldRotate() {
        var pager = givenPager
        pager = pager.rotation3D()
        XCTAssertTrue(pager.shouldRotate)
        XCTAssertEqual(pager.interactiveScale, pager.rotationInteractiveScale)
    }
    
    func test_GivenPagerWith3DRotation_When3DRotationFalse_ThenShouldRotateFalse() {
        var pager = givenPager.rotation3D()
        pager = pager.rotation3D(false)
        XCTAssertFalse(pager.shouldRotate)
        XCTAssertEqual(pager.interactiveScale, 1)
    }
    
    func test_GivenPager_WhenHorizontalRightToLeft_ThenScrollAngle() {
        var pager = givenPager.vertical()
        pager = pager.horizontal(.rightToLeft)
        XCTAssertTrue(pager.isHorizontal)
        XCTAssertEqual(pager.scrollDirectionAngle, Angle(degrees: 180))
    }

    func test_GivenPager_WhenAlignment_ThenAlignmentSet() {
        var pager = givenPager
        pager = pager.alignment(.end(10))
        XCTAssertEqual(pager.alignment, .end(10))
    }

    func test_GivenPager_WhenVerticalBottomToTop_ThenScrollAngle() {
        var pager = givenPager
        pager = pager.vertical(.bottomToTop)
        XCTAssertTrue(pager.isVertical)
        XCTAssertEqual(pager.scrollDirectionAngle, Angle(degrees: 180))
    }
    
    func test_GivenPager_WhenPageOffset_ThenPageOffset() {
        var pager = givenPager
        pager = pager.pageOffset(1.2)
        XCTAssertEqual(pager.pageOffset, 1.2)
    }
    
    func test_GivenPager_WhenItemSpacing_ThenItemSpacing() {
        var pager = givenPager
        pager = pager.itemSpacing(30)
        XCTAssertEqual(pager.itemSpacing, 30)
    }
    
    func test_GivenPager_WhenItemAspectRatioNotNil_ThenSetItemAspectRatio() {
        var pager = givenPager
        pager = pager.itemAspectRatio(1.2, alignment: .start(10))
        XCTAssertEqual(pager.itemAspectRatio, 1.2)
        XCTAssertTrue(pager.itemAlignment.equalsIgnoreValues(.start))
    }

    func test_GivenPager_WhenItemAspectAlignmentEnd_ThenItemAlignmentEnd() {
        var pager = givenPager
        pager = pager.itemAspectRatio(1, alignment: .end)
        XCTAssertTrue(pager.itemAlignment.equalsIgnoreValues(.end))
    }

    func test_GivenPager_WhenItemAspectAlignmentStart_ThenItemAlignmentStart() {
        var pager = givenPager
        pager = pager.itemAspectRatio(1, alignment: .start(10))
        XCTAssertTrue(pager.itemAlignment.equalsIgnoreValues(.start))
    }
    
    func test_GivenPager_WhenItemAspectRatioLesserThanZero_ThenDoNotSetItemAspectRatio() {
        var pager = givenPager
        pager = pager.itemAspectRatio(-1.2)
        XCTAssertNil(pager.itemAspectRatio)
    }
    
    func test_GivenPagerWithItemAspectRatio_WhenItemAspectRatioNil_ThenSetNil() {
        var pager = givenPager.itemAspectRatio(1.2)
        pager = pager.itemAspectRatio(nil)
        XCTAssertNil(pager.itemAspectRatio)
    }
    
    func test_GivenPagerWithItemAspectRatio_WhenExpandPageToEdges_ThenItemAspectRatioNil() {
        var pager = givenPager.itemAspectRatio(1.2)
        pager = pager.expandPageToEdges()
        XCTAssertNil(pager.itemAspectRatio)
    }
    
    func test_GivenHorizontalPager_WhenPaddingHorizontal_ThenNoInsets() {
        var pager = givenPager
        pager = pager.padding(.horizontal, 8)
        XCTAssertEqual(pager.sideInsets, 0)
    }
    
    func test_GivenVerticalPager_WhenPaddingVertical_ThenNoInsets() {
        var pager = givenPager.vertical()
        pager = pager.padding(.vertical, 8)
        XCTAssertEqual(pager.sideInsets, 0)
    }
    
    func test_GivenHorizontalPager_WhenPaddingVertical_ThenSideInsets() {
        var pager = givenPager
        pager = pager.padding(.vertical, 8)
        XCTAssertEqual(pager.sideInsets, 8)
    }
    
    func test_GivenVerticalPager_WhenPaddingHorizontal_ThenSideInsets() {
        var pager = givenPager.vertical()
        pager = pager.padding(.horizontal, 8)
        XCTAssertEqual(pager.sideInsets, 8)
    }
    
    func test_GivenHorizontalPager_WhenPaddingVertical_ThenMinTopAndBottom() {
        var pager = givenPager
        pager = pager.padding(EdgeInsets(top: 10, leading: 5, bottom: 15, trailing: 2))
        XCTAssertEqual(pager.sideInsets, 10)
    }
    
    func test_GivenVerticalPager_WhenPaddingHorizontal_ThenMinLeadingAndTrailing() {
        var pager = givenPager.vertical()
        pager = pager.padding(EdgeInsets(top: 10, leading: 5, bottom: 15, trailing: 2))
        XCTAssertEqual(pager.sideInsets, 2)
    }
    
    func test_GivenHorizontalPager_WhenPaddingVertical_ThenDefaultInsets() {
        var pager = givenPager
        pager = pager.padding(.vertical)
        XCTAssertEqual(pager.sideInsets, 8)
    }
    
    func test_GivenHorizontalPager_WhenPadding_ThenDefaultLengthVerticalInsets() {
        var pager = givenPager
        pager = pager.padding(5)
        XCTAssertEqual(pager.sideInsets, 5)
    }
    
    func test_GivenPager_WhenOnPageChanged_ThenObservePageChanges() {
        var pager = givenPager
        
        var newPage: Int! = nil
        pager = pager.onPageChanged({ (page) in
            newPage = page
        })
        
        pager.pageIndex = 3
        
        XCTAssertNotNil(newPage)
        XCTAssertEqual(pager.page, newPage)
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
        ("test_GivenPager_WhenHighPriorityGesture_ThenMinimumDistanceZero", test_GivenPager_WhenHighPriorityGesture_ThenMinimumDistanceZero),
        ("test_GivenPager_WhenItemAspectAlignmentEnd_ThenItemAlignmentEnd", test_GivenPager_WhenItemAspectAlignmentEnd_ThenItemAlignmentEnd),
        ("test_GivenPager_WhenItemAspectAlignmentStart_ThenItemAlignmentStart", test_GivenPager_WhenItemAspectAlignmentStart_ThenItemAlignmentStart),
        ("test_GivenPager_WhenDisableDragging_ThenAllowsDraggingFalse", test_GivenPager_WhenDisableDragging_ThenAllowsDraggingFalse),
        ("test_GivenPager_WhenAllowsDragging_ThenAllowsDraggingTrue", test_GivenPager_WhenAllowsDragging_ThenAllowsDraggingTrue),
        ("test_GivenPager_WhenAllowsDraggingFalse_ThenAllowsDraggingFalse", test_GivenPager_WhenAllowsDraggingFalse_ThenAllowsDraggingFalse),
        ("test_GivenPager_WhenLoopPages_ThenIsInfinitePagerTrue", test_GivenPager_WhenLoopPages_ThenIsInfinitePagerTrue)
    ]
}
