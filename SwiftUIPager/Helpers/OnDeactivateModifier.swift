//
//  OnDeactivateModifier.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 07/07/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

/// This modifier allows the `View` to listen to the `UIScene.didActivateNotification` in `iOS`
/// and perform an action when received.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct OnDeactivateView<Content: View>: View {

    var content: Content
    var perform: () -> Void

    var body: some View {
        #if os(iOS)
        return content
            .onReceive(NotificationCenter.default.publisher(for: UIScene.didActivateNotification), perform: { _ in
                self.perform()
            })
        #else
        return content
        #endif
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    func onDeactivate(perform: @escaping () -> Void) -> some View {
        return OnDeactivateView(content: self, perform: perform)
    }

}
