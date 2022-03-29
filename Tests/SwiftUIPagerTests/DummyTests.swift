//
//  File.swift
//  
//
//  Created by Fernando Moya de Rivas on 15/1/21.
//

import XCTest
import SwiftUI
@testable import SwiftUIPager

@available(iOS 13.2, *)
final class DummyTests: XCTestCase {

    func test_dummyGesturePriority() {
        let view = Text("dummy")
        _ = view.gesture(TapGesture(), priority: .high)
        _ = view.gesture(TapGesture(), priority: .default)
        _ = view.gesture(TapGesture(), priority: .simultaneous)
        _ = view.gesture(TapGesture(), priority: .normal)
    }

    func test_dummyOnAnimationCompleted() {
        let view = Text("dummy")
        _ = view.onAnimationCompleted(for: 1) { }
    }

    static var allTests = [
        ("test_dummyOnAnimationCompleted", test_dummyOnAnimationCompleted),
        ("test_dummyGesturePriority", test_dummyGesturePriority)
    ]

}
