//
//  Pager+Helper.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pager.PagerContent {
    
    #if !os(tvOS)
    
    /// `swipeGesture` translation on the X-Axis
    var draggingOffset: CGFloat {
        pagerModel.draggingOffset
    }

    /// `swipeGesture` last translation on the X-Axis
    var lastDraggingValue: DragGesture.Value? {
        pagerModel.lastDraggingValue
    }

    /// `swipeGesture` velocity on the X-Axis
    var draggingVelocity: Double {
        pagerModel.draggingVelocity
    }
    
    #endif

    /// Increment resulting from the last swipe
    var pageIncrement: Int {
        pagerModel.pageIncrement
    }

    /// Manages the number of items that should be displayed in the screen.
    var recyclingRatio: Int {
        switch contentLoadingPolicy {
        case .eager:
            return numberOfPages
        case .lazy(let ratio):
            return max(1, Int(ratio))
        }
    }

    /// Current page index
    var page: Int {
        pagerModel.index
    }

    /// `true` if `Pager` is vertical
    var isVertical: Bool {
        return !isHorizontal
    }

    /// `pageOffset` converted to scrollable offset
    var contentOffset: CGFloat {
        -CGFloat(pageOffset) * pageDistance
    }

    /// Size increment to be applied to a unfocs item when it comes to focus
    var scaleIncrement: CGFloat { 1 - interactiveScale }

    /// Total space between items. The spacing will be larger when `Pager` is interactive
    var interactiveItemSpacing: CGFloat {
        itemSpacing - (pageSize.width * scaleIncrement) / 2 + (isHorizontal ? 0 : (pageSize.height - pageSize.width) * (1 - scaleIncrement / 2))
    }

    /// `True` if the the user is dragging or some event is changing `contentOffset`
    var isDragging: Bool { abs(totalOffset) > 0 }

    /// The direction of the swipe gesture
    var direction: Direction? {
        guard totalOffset != 0 else { return nil }
        return totalOffset < 0 ? .forward : .backward
    }

    /// Current page index, sensitivity 50%. Will equal `page` if not dragging
    var currentPage: Int {
        currentPage(sensitivity: 0.5)
    }

    /// Current page index, based on sensitivity. Will equal `page` if not dragging
    func currentPage(sensitivity: CGFloat) -> Int {
        guard isDragging else { return page }
        let dOffset = totalOffset / pageDistance
        let remaining = dOffset - dOffset.rounded(.towardZero)
        let dPage = Int(dOffset.rounded(.towardZero)) + (abs(remaining) < sensitivity ? 0 : Int(remaining.rounded(.awayFromZero)))
        let newPage = page - dPage

        guard isInifinitePager else { return max(min(newPage, numberOfPages - 1), 0) }
        guard numberOfPages > 0 else { return 0 }
        return max((newPage + numberOfPages) % numberOfPages, 0)
    }

    /// Minimum offset allowed. This allows a bounce offset
    var offsetLowerbound: CGFloat {
        guard currentPage == 0, !isInifinitePager else { return CGFloat(numberOfPages) * self.size.width }
        let bounceOffset = bounces ? -pageDistance / 4 : -pageDistance / 2
        return CGFloat(numberOfPagesDisplayed) / 2 * pageDistance + bounceOffset + alignmentOffset
    }

    /// Maximum offset allowed. This allows a bounce offset
    var offsetUpperbound: CGFloat {
        guard currentPage == numberOfPages - 1, !isInifinitePager else { return -CGFloat(numberOfPages) * self.size.width }
        let a = -CGFloat(numberOfPagesDisplayed) / 2
        let bounceOffset = bounces ? pageDistance / 4 : pageDistance / 2
        return a * pageDistance + bounceOffset + alignmentOffset
    }

    /// Addition of `draggingOffset` and `contentOffset`
    var totalOffset: CGFloat {
        #if !os(tvOS)
        return draggingOffset + contentOffset
        #else
        return contentOffset
        #endif
    }

    /// Size of each item. Takes into account `itemAspectRatio` and `verticalInsets` to fit the page into its container
    var pageSize: CGSize {
        guard size != .zero else { return .zero }
        if let preferredItemSize = preferredItemSize {
            return CGSize(width: min(preferredItemSize.width, size.width),
                          height: min(preferredItemSize.height, size.height))
        }

        guard let itemAspectRatio = self.itemAspectRatio else {
            return CGSize(width: size.width - 2 * sideInsets, height: size.height - 2 * sideInsets)
        }

        let size = CGSize(width: self.size.width - 2 * sideInsets,
                          height: self.size.height - 2 * sideInsets)
        let side = min(size.width, size.height)
        
        if itemAspectRatio > 1 {
            return CGSize(width: side, height: side / itemAspectRatio)
        }
        return CGSize(width: side * itemAspectRatio, height: side)
    }

    /// Total distance between items
    var pageDistance: CGFloat {
        guard size != .zero else { return .zero }
        return pageSize.width + self.interactiveItemSpacing
    }

    /// Total number of pages
    var numberOfPages: Int { data.count }

    /// Maximum number in memory at the same time. Always an even number.
    var maximumNumberOfPages: Int {
        guard contentLoadingPolicy != .eager else { return numberOfPages }
        guard pageDistance != 0, numberOfPages > 0 else { return 0 }
        let side = isHorizontal ? size.width : size.height
        var number = Int((CGFloat(recyclingRatio) * side / pageDistance).rounded(.up))
        number = number.isMultiple(of: 2) ? (recyclingRatio.isMultiple(of: 2) ? number + 1 : number - 1) : number

        guard isInifinitePager else { return number }
        number = min(number, numberOfPages)
        return number.isMultiple(of: 2) ? number - 1 : number
    }

    /// Number of pages in memory at the moment
    var numberOfPagesDisplayed: Int {
        guard isInifinitePager else {
            return lowerPageDisplayed <= upperPageDisplayed ? (lowerPageDisplayed...upperPageDisplayed).count : 0
        }
        return maximumNumberOfPages
    }

    /// Data that is being displayed at the moment
    var dataDisplayed: [PageWrapper<Element, ID>] {
        var items: [PageWrapper<Element, ID>] = []

        var index = lowerPageDisplayed
        while items.count < numberOfPagesDisplayed {
            items.append(data[index])
            index = (index + 1) % numberOfPages
        }

        return items
    }

    /// Lower bound of the data displaed
    var lowerPageDisplayed: Int {
        guard isInifinitePager else {
            return contentLoadingPolicy == .eager ? 0 : max(0, page - maximumNumberOfPages / 2)
        }
        guard numberOfPages > 0 else { return 0 }
        return ((page - maximumNumberOfPages / 2) + numberOfPages) % numberOfPages
    }

    /// Upper bound of the data displaed
    var upperPageDisplayed: Int {
        guard isInifinitePager else {
            return contentLoadingPolicy == .eager ? numberOfPages - 1 : min(numberOfPages - 1, page + maximumNumberOfPages / 2)
        }
        guard numberOfPages > 0 else { return 0 }
        return (Int((Float(maximumNumberOfPages) / 2).rounded(.up)) + page) % numberOfPages
    }

    /// Extra offset to complentate the alignment
    var alignmentOffset: CGFloat {
        let indexOfPageFocused = dataDisplayed.firstIndex(where: { data.firstIndex(of: $0) == self.page }) ?? 0

        let offset: CGFloat
        switch (alignment, indexOfPageFocused) {
        case (.end(let insets), _), (.justified(let insets), dataDisplayed.count - 1):
            if isVertical {
                offset = (size.height - pageSize.height) / 2 - insets
            } else {
                offset = (size.width - pageSize.width) / 2 - insets
            }
        case (.start(let insets), _), (.justified(let insets), 0):
            if isVertical {
                offset = -(size.height - pageSize.height) / 2 + insets
            } else {
                offset = -(size.width - pageSize.width) / 2 + insets
            }
        case (.center, _), (.justified, _):
            offset = 0
        }

        return offset
    }

    /// Offset applied to `HStack` along the Y-Axis. Used to aligned the pages
    var yOffset: CGFloat {
        guard !itemAlignment.equalsIgnoreValues(.center) else { return 0 }
        guard !itemAlignment.equalsIgnoreValues(.justified) else { return 0 }
        guard itemAspectRatio != nil || preferredItemSize != nil else { return 0 }

        let availableSpace = ((isHorizontal ? size.height - pageSize.height : size.width - pageSize.width) - sideInsets) / 2 - itemAlignment.insets
        guard availableSpace > 0 else { return 0 }

        let multiplier: CGFloat = isVertical ? -1 : 1
        return (itemAlignment.equalsIgnoreValues(.start) ? -availableSpace : availableSpace) * multiplier
    }

    /// Oppacity for each item when `faded` animation is chosen
    func opacity(for item: PageWrapper<Element, ID>) -> Double {
        guard let opacityIncrement = opacityIncrement else { return 1 }
        guard let index = data.firstIndex(of: item) else { return 1 }
        let totalIncrement = abs(totalOffset / pageDistance)
        let currentPage = direction == .forward ? CGFloat(page) + totalIncrement : CGFloat(page) - totalIncrement

        let distance = abs(CGFloat(index) - currentPage)
        return Double(max(0, min(1, 1 - distance * CGFloat(opacityIncrement))))
    }

    /// Offset applied to `HStack` along the X-Axis. It's limitted by `offsetUpperbound` and `offsetUpperbound`
    var xOffset: CGFloat {
        let indexOfPageFocused = CGFloat(dataDisplayed.firstIndex(where: { data.firstIndex(of: $0) == self.page }) ?? 0)
        let numberOfPages = CGFloat(numberOfPagesDisplayed)
        let xIncrement = pageDistance / 2
        let offset = (numberOfPages / 2 - indexOfPageFocused) * pageDistance - xIncrement + totalOffset + alignmentOffset

        return max(offsetUpperbound, min(offsetLowerbound, offset))
    }

    /// Angle for the 3D rotation effect
    func angle(for item: PageWrapper<Element, ID>) -> Angle {
        guard shouldRotate else { return .zero }
        guard let index = data.firstIndex(of: item) else { return .zero }

        let totalIncrement = abs(totalOffset / pageDistance)

        let currentAngle = Angle(degrees: Double(page - index) * rotationDegrees)
        guard isDragging else {
            return currentAngle
        }

        let newAngle = direction == .forward ? Angle(degrees: currentAngle.degrees + rotationDegrees * Double(totalIncrement)) : Angle(degrees: currentAngle.degrees - rotationDegrees * Double(totalIncrement) )
        return newAngle
    }

    /// Axis for the rotations effect
    var axis: (CGFloat, CGFloat, CGFloat) {
        guard shouldRotate else { return (0, 0, 0) }
        return rotationAxis
    }

    /// Scale that applies to a particular item
    func scale(for item: PageWrapper<Element, ID>) -> CGFloat {
        guard isDragging else { return isFocused(item) ? 1 : interactiveScale }

        let totalIncrement = abs(totalOffset / pageDistance)
        let currentPage = direction == .forward ? CGFloat(page) + totalIncrement : CGFloat(page) - totalIncrement

        guard let indexInt = data.firstIndex(of: item) else { return interactiveScale }

        let index = CGFloat(indexInt)
        guard abs(currentPage - index) <= 1 else { return interactiveScale }

        let increment = totalIncrement - totalIncrement.rounded(.towardZero)
        let nextPage = direction == .forward ? currentPage.rounded(.awayFromZero) : currentPage.rounded(.towardZero)
        guard currentPage > 0 else {
            return 1 - (scaleIncrement * increment)
        }

        return index == nextPage ? interactiveScale + (scaleIncrement * increment)
            : 1 - (scaleIncrement * increment)
    }

    /// Returns true if the item is focused on the screen.
    func isFocused(_ item: PageWrapper<Element, ID>) -> Bool {
        data.firstIndex(of: item) == currentPage
    }

    /// Returns true if the item is the first or last element in memory. Just used when `isInfinitePager` is set to `true` to hide elements being resorted.
    func isEdgePage(_ item: PageWrapper<Element, ID>) -> Bool {
        guard data.count >= 3 else { return false }
        guard !isDragging else { return false }
        guard let index = dataDisplayed.firstIndex(of: item) else { return false }
        let limit = max(pageIncrement, 1)
        return index < limit || index > dataDisplayed.count - 1 - limit
    }

}
