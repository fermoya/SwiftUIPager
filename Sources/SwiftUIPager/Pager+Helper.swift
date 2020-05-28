//
//  Pager+Helper.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
extension Pager {

    /// Work around to avoid @State keeps wrong value
    var page: Int {
        return min(pageIndex, numberOfPages - 1)
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

    /// The current page index. Will equal `page` if not dragging
    var currentPage: Int {
        guard isDragging else { return page }
        let newPage = -Int((totalOffset / pageDistance).rounded()) + page

        guard isInifinitePager else { return max(min(newPage, numberOfPages - 1), 0) }
        return max((newPage + numberOfPages) % numberOfPages, 0)
    }

    /// Minimum offset allowed. This allows a bounce offset
    var offsetLowerbound: CGFloat {
        guard currentPage == 0, !isInifinitePager else { return CGFloat(numberOfPages) * self.size.width }
        return CGFloat(numberOfPagesDisplayed) / 2 * pageDistance - pageDistance / 4 + alignmentOffset
    }

    /// Maximum offset allowed. This allows a bounce offset
    var offsetUpperbound: CGFloat {
        guard currentPage == numberOfPages - 1, !isInifinitePager else { return -CGFloat(numberOfPages) * self.size.width }
        let a = -CGFloat(numberOfPagesDisplayed) / 2
        let b = pageDistance / 4
        return a * pageDistance + b + alignmentOffset
    }

    /// Addition of `draggingOffset` and `contentOffset`
    var totalOffset: CGFloat {
        draggingOffset + contentOffset
    }

    /// Size of each item. Takes into account `pageAspectRatio` and `verticalInsets` to fit the page into its container
    var pageSize: CGSize {
        guard let itemAspectRatio = self.itemAspectRatio else {
            return CGSize(width: size.width - 2 * sideInsets, height: size.height - 2 * sideInsets)
        }

        let size = CGSize(width: self.size.width - 2 * sideInsets,
                          height: self.size.height - 2 * sideInsets)
        let side = min(size.width, size.height)
        
        if itemAspectRatio > 1 {
            return CGSize(width: side, height: side / itemAspectRatio)
        } else {
            return CGSize(width: side * itemAspectRatio, height: side)
        }
    }

    /// Total distance between items
    var pageDistance: CGFloat {
        pageSize.width + self.interactiveItemSpacing
    }

    /// Total number of pages
    var numberOfPages: Int { data.count }

    /// Maximum number in memory at the same time. Always an even number.
    var maximumNumberOfPages: Int {
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
            return (lowerPageDisplayed...upperPageDisplayed).count
        }
        return maximumNumberOfPages
    }

    /// Data that is being displayed at the moment
    var dataDisplayed: [Element] {
        var items: [Element] = []

        var index = lowerPageDisplayed
        while items.count < numberOfPagesDisplayed {
            items.append(data[index])
            index = (index + 1) % numberOfPages
        }

        return items
    }

    /// Lower bound of the data displaed
    var lowerPageDisplayed: Int {
        guard isInifinitePager else { return max(0, page - maximumNumberOfPages / 2) }
        return ((page - maximumNumberOfPages / 2) + numberOfPages) % numberOfPages
    }

    /// Upper bound of the data displaed
    var upperPageDisplayed: Int {
        guard isInifinitePager else { return min(numberOfPages - 1, page + maximumNumberOfPages / 2) }
        return (Int((Float(maximumNumberOfPages) / 2).rounded(.up)) + page) % numberOfPages
    }

    /// Extra offset to complentate the alignment
    var alignmentOffset: CGFloat {
        let offset: CGFloat
        switch alignment {
        case .center:
            offset = 0
        case .end(let insets):
            if isVertical {
                offset = (size.height - pageSize.height) / 2 - insets
            } else {
                offset = (size.width - pageSize.width) / 2 - insets
            }
        case .start(let insets):
            if isVertical {
                offset = -(size.height - pageSize.height) / 2 + insets
            } else {
                offset = -(size.width - pageSize.width) / 2 + insets
            }
        }

        return offset
    }

    /// Offset applied to `HStack` along the Y-Axis. Used to aligned the pages
    var yOffset: CGFloat {
        guard !itemAlignment.equalsIgnoreValues(.center) else { return 0 }
        guard itemAspectRatio != nil else { return 0 }

        let availableSpace = ((isHorizontal ? size.height - pageSize.height : size.width - pageSize.width) - sideInsets) / 2 - itemAlignment.insets
        guard availableSpace > 0 else { return 0 }

        let multiplier: CGFloat = isVertical ? -1 : 1
        return (itemAlignment.equalsIgnoreValues(.start) ? -availableSpace : availableSpace) * multiplier
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
    func angle(for item: Element) -> Angle {
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
    func axis(for item: Element) -> (CGFloat, CGFloat, CGFloat) {
        guard shouldRotate else { return (0, 0, 0) }
        return rotationAxis
    }

    /// Scale that applies to a particular item
    func scale(for item: Element) -> CGFloat {
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
    func isFocused(_ item: Element) -> Bool {
        data.firstIndex(of: item) == currentPage
    }

    /// Returns true if the item is the first or last element in memory. Just used when `isInfinitePager` is set to `true` to hide elements being resorted.
    func isEdgePage(_ item: Element) -> Bool {
        guard numberOfPages >= 3 else { return false }
        guard let index = dataDisplayed.firstIndex(of: item) else { return false }
        return index == 0 || index == dataDisplayed.count - 1
    }

}
