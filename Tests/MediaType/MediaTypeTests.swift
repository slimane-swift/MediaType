import XCTest
@testable import MediaType

class MediaTypeTests: XCTestCase {
    func testReality() {
        XCTAssert(2 + 2 == 4, "Something is severely wrong here.")
    }
}

extension MediaTypeTests {
    static var allTests: [(String, MediaTypeTests -> () throws -> Void)] {
        return [
           ("testReality", testReality),
        ]
    }
}
