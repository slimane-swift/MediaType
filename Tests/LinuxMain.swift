#if os(Linux)

import XCTest
@testable import MediaTypeTestSuite

XCTMain([
    testCase(MediaTypeTests.allTests)
])

#endif
