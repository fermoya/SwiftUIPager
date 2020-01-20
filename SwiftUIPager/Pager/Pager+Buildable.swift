//
//  Pager+ViewModifiers.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

extension Pager: Buildable {
    
    func interactive(_ scale: CGFloat) -> Self {
        let scale = min(1, abs(scale))
        return mutating(keyPath: \.interactiveScale, value: scale)
    }

    func pageOffset(_ pageOffset: Double) -> Self {
        let contentOffset = CGFloat(pageOffset) * pageDistance
        return mutating(keyPath: \.contentOffset, value: contentOffset)
    }

    func itemShadowColor(_ color: Color) -> Self {
        mutating(keyPath: \.shadowColor, value: color)
    }
    
    func itemSpacing(_ value: CGFloat) -> Self {
        mutating(keyPath: \.itemSpacing, value: value)
    }
    
    func pageAspectRatio(_ value: CGFloat) -> Self {
        mutating(keyPath: \.pageAspectRatio, value: value)
    }

    func onPageChanged(_ onPageChanged: ((Int) -> Void)?) -> Self {
        mutating(keyPath: \.onPageChanged, value: onPageChanged)
    }
    
    func padding(_ length: CGFloat) -> Self {
        padding(.all, length)
    }
    
    func padding(_ insets: EdgeInsets) -> Self {
        let length = min(insets.top, insets.bottom)
        return padding(.vertical, length)
    }
    
    func padding(_ edges: Edge.Set = .all, _ length: CGFloat? = nil) -> Self {
        guard edges == .all || edges == .vertical else { return self }
        return mutating(keyPath: \.verticalInsets, value: length ?? 8)
    }

}
