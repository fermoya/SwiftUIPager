import XCTest
import SwiftUI
@testable import SwiftUIPager

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
final class View_Helper_Tests: XCTestCase {
    
    func test_GivenView_WhenFrameWithSize_Then_Frame() {
        let inputSize = CGSize(width: 100, height: 200)

        let view1 = EmptyView().frame(size: inputSize)
        let view2 = EmptyView().frame(width: inputSize.width, height: inputSize.height)

        XCTAssertEqual("\(view1)", "\(view2)")
    }
    
    static var allTests = [
        ("test_GivenView_WhenFrameWithSize_Then_Frame", test_GivenView_WhenFrameWithSize_Then_Frame),
    ]
}
