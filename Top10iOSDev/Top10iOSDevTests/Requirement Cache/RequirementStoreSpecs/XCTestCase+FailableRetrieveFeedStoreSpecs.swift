//
//  XCTestCase+FailableRetrieveFeedStoreSpecs.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 24/02/2021.
//

import XCTest
import Top10iOSDev

extension FailableRetrieveRequirementStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
    }

    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
    }
}
