//
//  File.swift
//  
//
//  Created by Fernando Moya de Rivas on 05/08/2020.
//

import XCTest
import SwiftUI
@testable import SwiftUIPager

final class OnDeactivateModifier_Tests: XCTestCase {

    func test_GivenView_WhenOnDeactivate_ThenPerformAction() {
        #if os(iOS)

        let view = Text("")
        let expectation = self.expectation(description: "UIScene.didActivateNotification triggers action callback")

        let subject = view.onDeactivate {
            expectation.fulfill()
        }

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIHostingController(rootView: subject)
        window.makeKeyAndVisible()

        DispatchQueue.main.async {
            NotificationCenter.default.post(Notification(name: UIScene.didActivateNotification))
        }
        waitForExpectations(timeout: 1, handler: nil)

        #endif
    }

    static var allTests = [
        ("test_GivenView_WhenOnDeactivate_ThenPerformAction", test_GivenView_WhenOnDeactivate_ThenPerformAction),
    ]

}
