//
//  Pager+Helper.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

extension Pager {
    
    var scaleIncrement: CGFloat { 1 - interactiveScale }
    var interactiveItemSpacing: CGFloat { itemSpacing - (pageSize.width * scaleIncrement) / 2 }
    var isDragging: Bool { abs(totalOffset) > 0 }

    var direction: Direction? {
        guard totalOffset != 0 else { return nil }
        return totalOffset < 0 ? .forward : .backward
    }

    var currentPage: Int {
        guard isDragging else { return page }
        let newPage = -Int((totalOffset / self.pageDistance).rounded()) + self.page
        return max(min(newPage, self.numberOfPages - 1), 0)
    }
    
    var offsetLowerbound: CGFloat {
        guard currentPage == 0 else { return CGFloat(numberOfPages) * self.size.width }
        return CGFloat(numberOfPagesDisplayed) / 2 * pageDistance - pageDistance / 4
    }
    
    var offsetUpperbound: CGFloat {
        guard currentPage == numberOfPages - 1 else { return -CGFloat(numberOfPages) * self.size.width }
        return -CGFloat(numberOfPagesDisplayed) / 2 * pageDistance + pageDistance / 4
    }

    var totalOffset: CGFloat {
        draggingOffset + contentOffset
    }
    
    var pageSize: CGSize {
        let size = CGSize(width: self.size.width - 2 * verticalInsets,
                          height: self.size.height - 2 * verticalInsets)
        let side = min(size.width, size.height)
        if pageAspectRatio > 1 {
            return CGSize(width: side, height: side / pageAspectRatio)
        } else {
            return CGSize(width: side * pageAspectRatio, height: side)
        }
    }

    var pageDistance: CGFloat {
        pageSize.width + self.interactiveItemSpacing
    }
    
    var numberOfPages: Int { data.count }

    var maximumNumberOfPages: Int {
        guard pageDistance != 0 else { return 0 }
        return Int((CGFloat(recyclingRatio) * size.width / pageDistance / 2).rounded(.up))
    }

    var numberOfPagesDisplayed: Int {
        upperPageDisplayed - lowerPageDisplayed
    }

    var dataDisplayed: [Data] {
        Array(data[lowerPageDisplayed..<upperPageDisplayed])
    }

    var lowerPageDisplayed: Int {
        return max(0, page - maximumNumberOfPages)
    }

    var upperPageDisplayed: Int {
        return min(numberOfPages, maximumNumberOfPages + page)
    }

    var xOffset: CGFloat {
        let page = CGFloat(self.page - lowerPageDisplayed)
        let numberOfPages = CGFloat(numberOfPagesDisplayed)
        let xIncrement = pageDistance / 2
        let offset = (numberOfPages / 2 - page) * pageDistance - xIncrement + totalOffset
        return max(offsetUpperbound, min(offsetLowerbound, offset))
    }
    
    func scale(for item: Data) -> CGFloat {
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

    func isFocused(_ item: Data) -> Bool {
        data.firstIndex(of: item) == currentPage
    }

}
