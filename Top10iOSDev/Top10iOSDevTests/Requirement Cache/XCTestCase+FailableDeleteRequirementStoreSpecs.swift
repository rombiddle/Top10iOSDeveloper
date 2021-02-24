//
//  XCTestCase+FailableDeleteRequirementStoreSpecs.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 24/02/2021.
//

import XCTest
import Top10iOSDev

extension FailableDeleteRequirementStoreSpecs where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)

        XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
    }

    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)

        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
 }
