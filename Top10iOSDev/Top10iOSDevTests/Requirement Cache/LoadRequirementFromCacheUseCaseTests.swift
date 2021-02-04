//
//  LoadRequirementFromCacheUseCaseTests.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 04/02/2021.
//

import XCTest
import Top10iOSDev

class LoadRequirementFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalRequirementLoader, store: RequirementStoreSpy) {
        let store = RequirementStoreSpy()
        let sut = LocalRequirementLoader(store: store)
        trackForMemotyLeaks(sut, file: file, line: line)
        trackForMemotyLeaks(store, file: file, line: line)
        return (sut, store)
    }

}
