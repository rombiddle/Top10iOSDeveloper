//
//  CacheFeedUseCaseTests.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 25/01/2021.
//

import XCTest

class LocalRequirementLoader {
    let store: RequirementStore
    
    init(store: RequirementStore) {
        self.store = store
    }
}

class RequirementStore {
    var deleteCachedRequirementsCallCount: Int = 0
}

class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDeleteCacheUponCreation() {
        let store = RequirementStore()
        _ = LocalRequirementLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedRequirementsCallCount, 0)
    }

}
