//
//  SizeViewModifier.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

/// Tracks the size of the view
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        let newValue = nextValue()
        guard value != newValue else { return }
        value = newValue
    }
}

/// This modifier wraps a view into a `GeometryReader` and tracks the available space by using `SizePreferenceKey` on the content
struct SizeViewModifier: ViewModifier {
    
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .preference(key: SizePreferenceKey.self,
                            value: proxy.size)
                .onPreferenceChange(SizePreferenceKey.self, perform: { (newSize) in
                    self.size = newSize
                })
        }
        .clipped()
    }
}

extension View {

    /// Tracks the size available for the view
    ///
    /// - Parameter size:   This binding will receive the size updates
    func sizeTrackable(_ size: Binding<CGSize>) -> some View {
        self.modifier(SizeViewModifier(size: size))
    }
    
}
