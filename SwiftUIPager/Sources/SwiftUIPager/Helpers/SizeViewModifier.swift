//
//  SizeViewModifier.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SizeViewModifier: ViewModifier {
    
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .preference(key: SizePreferenceKey.self,
                            value: proxy.size)
        }.onPreferenceChange(SizePreferenceKey.self, perform: { (newSize) in
            self.size = newSize
        })
    }
}

extension View {
    
    func sizeTrackable(_ size: Binding<CGSize>) -> some View {
        self.modifier(SizeViewModifier(size: size))
    }
    
}
