import XCTest

extension XCTestCase {
    func assertNoThrow(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (() throws -> Void)
    ) {
        do {
            try closure()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)", file: file, line: line)
        }
    }
    
    func assertNoThrowAsync(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (() async throws -> Void)
    ) async {
        do {
            try await closure()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)", file: file, line: line)
        }
    }
    
    func assertThrows<T: Error>(
        expected error: T,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (() throws -> Void)
    ) {
        let expectation = XCTestExpectation(description: "throws expected error")
        
        do {
            try closure()
        } catch _ as T {
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)", file: file, line: line)
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func assertThrowsAsync<T: Error>(
        expected error: T,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (() async throws -> Void)
    ) async {
        let expectation = XCTestExpectation(description: "throws expected error")
        
        do {
            try await closure()
        } catch _ as T {
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)", file: file, line: line)
        }
        
        await fulfillment(of: [expectation], timeout: 0.1)
    }
}
