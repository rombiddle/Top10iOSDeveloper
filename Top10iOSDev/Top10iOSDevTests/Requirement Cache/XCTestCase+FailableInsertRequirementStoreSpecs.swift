//
//  XCTestCase+FailableInsertRequirementStoreSpecs.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 24/02/2021.
//

import XCTest
import Top10iOSDev

extension FailableInsertRequirementStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert(uniqueItems().locals, to: sut)

        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }

    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        insert(uniqueItems().locals, to: sut)

        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
}
