import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Pager_Buildable_Tests.allTests),
        testCase(View_Helper_Tests.allTests),
        testCase(Pager_Helper_Tests.allTests),
        testCase(PositionAlignment_Tests)
    ]
}
#endif
