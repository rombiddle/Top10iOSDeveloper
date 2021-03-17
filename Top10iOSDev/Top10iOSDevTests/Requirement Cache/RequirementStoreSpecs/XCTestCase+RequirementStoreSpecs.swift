//
//  XCTestCase+RequirementStoreSpecs.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 23/02/2021.
//

import XCTest
import Top10iOSDev

extension RequirementStoreSpecs where Self: XCTestCase {

    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }

    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .success(.none), file: file, line: line)
    }

    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        let requirements = uniqueItems().locals
                
        insert(requirements, to: sut)
                
        expect(sut, toRetrieve: .success(CachedRequirements(requirements: requirements)))
    }

    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        let requirements = uniqueItems().locals
                
        insert(requirements, to: sut)
                
        expect(sut, toRetrieveTwice: .success(CachedRequirements(requirements: requirements)))
    }

    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert(uniqueItems().locals, to: sut)
                
        XCTAssertNil(insertionError, "Expected to override cache successfully")
    }

    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        insert(uniqueItems().locals, to: sut)
                
        let lastestRequirements = uniqueItems().locals
        insert(lastestRequirements, to: sut)
                
        expect(sut, toRetrieve: .success(CachedRequirements(requirements: lastestRequirements)))
    }

    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        insert(uniqueItems().locals, to: sut)
                
        let lastestRequirements = uniqueItems().locals
        insert(lastestRequirements, to: sut)
                
        expect(sut, toRetrieve: .success(CachedRequirements(requirements: lastestRequirements)))
    }

    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)

        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
    }

    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)

        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }

    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        insert(uniqueItems().locals, to: sut)

        let deletionError = deleteCache(from: sut)

        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")

    }

    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        insert(uniqueItems().locals, to: sut)

        deleteCache(from: sut)

        expect(sut, toRetrieve: .success(.none))
    }

    func assertThatSideEffectsRunSerially(on sut: RequirementStore, file: StaticString = #file, line: UInt = #line) {
        var completedOperationsInOrder = [XCTestExpectation]()
                
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueItems().locals) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedRequirements { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueItems().locals) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")
     }

 }

extension RequirementStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveEmptyOnEmptyCache(on sut: RequirementStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none))
    }
    
    @discardableResult
    func insert(_ requirements: [LocalRequirementCategory], to sut: RequirementStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(requirements) { result in
            if case let Result.failure(error) = result { insertionError = error }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    func deleteCache(from sut: RequirementStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedRequirements { result in
            if case let Result.failure(error) = result { deletionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    func expect(_ sut: RequirementStore, toRetrieve expectedResult: RequirementStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.success(.none), .success(.none)),
                 (.failure, .failure):
                break
                
            case let (.success(.some(expected)), .success(.some(retrieved))):
                XCTAssertEqual(expected.requirements, retrieved.requirements)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func expect(_ sut: RequirementStore, toRetrieveTwice expectedResult: RequirementStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
}
