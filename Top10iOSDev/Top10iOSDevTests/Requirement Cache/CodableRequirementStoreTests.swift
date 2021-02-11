//
//  CodableRequirementStoreTests.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 10/02/2021.
//

import XCTest
import Top10iOSDev

class CodableRequirementStore {
    private let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("requirements.store")
    
    func retrieve(completion: @escaping RequirementStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode([LocalRequirementCategory].self, from: data)
        completion(.found(requirements: decoded))
    }
    
    func insert(_ items: [LocalRequirementCategory], completion: @escaping RequirementStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(items)
        try! encoded.write(to: storeURL)
        completion(nil)
    }
}

class CodableRequirementStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("requirements.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    override func tearDown() {
        super.tearDown()
        
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("requirements.store")
        try? FileManager.default.removeItem(at: storeURL)
    }

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
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = CodableRequirementStore()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                    
                default:
                    XCTFail("Expected retrieving twice from empty cacheto deliver same empty result, got \(firstResult) and \(firstResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = CodableRequirementStore()
        let requirements = uniqueItems().locals
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.insert(requirements) { insertionError in
            XCTAssertNil(insertionError, "Expected requirements to be inserted successfully")
            
            sut.retrieve { retrieveResult in
                switch retrieveResult {
                case let .found(retrievedRequirements):
                    XCTAssertEqual(retrievedRequirements, requirements)
                    
                default:
                    XCTFail("Expected found result with requirements \(requirements), got \(retrieveResult) instead")
                }
                
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }

}
