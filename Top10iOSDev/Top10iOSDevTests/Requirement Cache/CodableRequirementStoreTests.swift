//
//  CodableRequirementStoreTests.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 10/02/2021.
//

import XCTest
import Top10iOSDev

class CodableRequirementStore {
    func retrieve(completion: @escaping RequirementStore.RetrievalCompletion) {
        completion(.empty)
    }
}

class CodableRequirementStoreTests: XCTestCase {

    func test_retrieve_delivresEmptyOnEmptyCache() {
        let sut = CodableRequirementStore()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { result in
            switch result {
            case .empty:
                break
                
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }

}
