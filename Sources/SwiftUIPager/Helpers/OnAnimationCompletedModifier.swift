//
//  OnAnimationCompletedModifier.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 14/1/21.
//  Copyright © 2021 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

/// `ViewModifier` used to observe the end of an animation
@available(iOS 13.2, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
struct OnAnimationCompletedModifier<Value>: AnimatableModifier where Value: VectorArithmetic {

    var animatableData: Value {
        didSet {
            notifyCompletionIfFinished()
        }
    }

    private var target: Value
    private var completion: () -> Void

    init(target: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = target
        self.target = target
    }

    private func notifyCompletionIfFinished() {
        guard animatableData == target else { return }
        DispatchQueue.main.async {
            self.completion()
        }
    }

    func body(content: Content) -> some View {
        content
    }
}

@available(iOS 13.2, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {

    /// Calls the completion handler whenever an animation on the given value completes.
    ///
    /// - Parameter value: The value to observe
    /// - Parameter completion: The completion callback
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> some View {
        return modifier(OnAnimationCompletedModifier(target: value, completion: completion))
    }
}
