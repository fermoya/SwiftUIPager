//
//  SizeViewModifier.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

/// This modifier wraps a view into a `GeometryReader` and tracks the available space by using `SizePreferenceKey` on the content
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct SizeViewModifier: ViewModifier {
    
    @Binding var size: CGSize
    @State private var isAppeared = false

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .frame(width: proxy.size.width, height: proxy.size.height)
                .onReload (perform: {
                    self.size = proxy.size
                })
        }
        .clipped()
    }

}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    func onReload(perform: @escaping () -> Void) -> some View {
        DispatchQueue.main.async {
            perform()
        }

        return self
    }

}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Tracks the size available for the view
    ///
    /// - Parameter size:   This binding will receive the size updates
    func sizeTrackable(_ size: Binding<CGSize>) -> some View {
        self.modifier(SizeViewModifier(size: size))
    }
    
}
