import XCTest
import OSLog
import Foundation
@testable import E_Eum

let logger: Logger = Logger(subsystem: "E_Eum", category: "Tests")

@available(macOS 13, *)
final class E_EumTests: XCTestCase {

    func testE_Eum() throws {
        logger.log("running testE_Eum")
        XCTAssertEqual(1 + 2, 3, "basic test")
    }

    func testDecodeType() throws {
        // load the TestData.json file from the Resources folder and decode it into a struct
        let resourceURL: URL = try XCTUnwrap(Bundle.module.url(forResource: "TestData", withExtension: "json"))
        let testData = try JSONDecoder().decode(TestData.self, from: Data(contentsOf: resourceURL))
        XCTAssertEqual("E_Eum", testData.testModuleName)
    }

}

struct TestData : Codable, Hashable {
    var testModuleName: String
}
