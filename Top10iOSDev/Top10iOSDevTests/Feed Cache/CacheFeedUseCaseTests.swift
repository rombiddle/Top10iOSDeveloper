//
//  CacheFeedUseCaseTests.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 25/01/2021.
//

import XCTest
import Top10iOSDev

class LocalRequirementLoader {
    let store: RequirementStore
    
    init(store: RequirementStore) {
        self.store = store
    }
    
    func save(_ items: [RequirementCategory]) {
        store.deleteCachedRequirements()
    }
}

class RequirementStore {
    var deleteCachedRequirementsCallCount: Int = 0
    
    func deleteCachedRequirements() {
        deleteCachedRequirementsCallCount += 1
    }
}

class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.deleteCachedRequirementsCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedRequirementsCallCount, 1)
    }
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalRequirementLoader, store: RequirementStore) {
        let store = RequirementStore()
        let sut = LocalRequirementLoader(store: store)
        trackForMemotyLeaks(sut, file: file, line: line)
        trackForMemotyLeaks(store, file: file, line: line)
        return (sut, store)
    }
    
    private func uniqueItem() -> RequirementCategory {
        RequirementCategory(id: UUID(), name: "any", groups: [])
    }

}
