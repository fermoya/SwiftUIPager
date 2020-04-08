//
//  SizeViewModifier.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

/// This modifier wraps a view into a `GeometryReader` and tracks the available space by using `SizePreferenceKey` on the content
struct SizeViewModifier: ViewModifier {
    
    @Binding var size: CGSize
    @State private var isAppeared = false

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .frame(width: proxy.size.width, height: proxy.size.height)
                .onReload (perform: {
                    guard self.isAppeared else { return }
                    self.size = proxy.size
                })
                .onAppear {
                    self.size = proxy.size
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                        self.isAppeared = true
                    }
                }
        }
        .clipped()
    }

}

extension View {

    func onReload(perform: @escaping () -> Void) -> some View {
        DispatchQueue.main.async {
            perform()
        }

        return self
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
