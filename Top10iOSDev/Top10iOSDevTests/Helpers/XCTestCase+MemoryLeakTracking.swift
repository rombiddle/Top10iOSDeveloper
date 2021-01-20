//
//  XCTestCase+MemoryLeakTracking.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 20/01/2021.
//

import XCTest

extension XCTestCase {
    func trackForMemotyLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
