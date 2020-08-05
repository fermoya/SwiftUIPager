import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Pager_Buildable_Tests.allTests),
        testCase(View_Helper_Tests.allTests),
        testCase(PagerContent_Helper_Tests.allTests),
        testCase(PositionAlignment_Tests.allTests),
        testCase(PagerWrapper_Tests.allTests),
        testCase(CGPoint+Angle_Tests.allTests),
        testCase(OnDeactivateModifier_Tests.allTests),
        testCase(PagingAnimation_Tests.allTests)
    ]
}
#endif
