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
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(retrievalError)) {
            store.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_load_DeliversNoRequirementsOnEmptyCache() {
        let (sut, store) = makeSUT()

        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrievalWithEmptyCache()
        }
    }
    
    func test_load_DeliversRequirements() {
        let (sut, store) = makeSUT()
        let requirements = uniqueItems()

        expect(sut, toCompleteWith: .success(requirements.models)) {
            store.completeRetrieval(with: requirements.locals)
        }
    }
    
    func test_load_hasNoSideEffectsOnretrievalError() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = RequirementStoreSpy()
        var sut: LocalRequirementLoader? = LocalRequirementLoader(store: store)
        
        var receivedResult = [LocalRequirementLoader.LoadResult]()
        sut?.load { receivedResult.append($0) }
        
        sut = nil
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    // MARK: Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalRequirementLoader, store: RequirementStoreSpy) {
        let store = RequirementStoreSpy()
        let sut = LocalRequirementLoader(store: store)
        trackForMemotyLeaks(sut, file: file, line: line)
        trackForMemotyLeaks(store, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalRequirementLoader, toCompleteWith expectedResult: LocalRequirementLoader.LoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedRequirements), .success(expectedRequirements)):
                XCTAssertEqual(receivedRequirements, expectedRequirements, file: file, line: line)
                
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead")
            }
            
            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
    
    private func uniqueItem() -> RequirementCategory {
        let items = [RequirementItem(id: UUID(), name: "any", type: .done(true))]
        let groups = [RequirementGroup(id: UUID(), name: "any", items: items)]
        return RequirementCategory(id: UUID(), name: "any", groups: groups)
    }
    
    private func uniqueItems() -> (models: [RequirementCategory], locals: [LocalRequirementCategory]) {
        let items = [uniqueItem(), uniqueItem()]
        let localItems = items.map { cat in
            return LocalRequirementCategory(id: cat.id, name: cat.name, groups: cat.groups.map { group in
                return LocalRequirementGroup(id: group.id, name: group.name, items: group.items.map { item in
                    var type: LocalRequirementType = .done(true)
                    switch item.type {
                    case let .done(isDone): type = LocalRequirementType.done(isDone)
                    case let .level(myLevel): type = LocalRequirementType.level(myLevel)
                    case let .number(myNb, myTitle): type = LocalRequirementType.number(myNb, myTitle)
                    }
                    return LocalRequirementItem(id: item.id, name: item.name, type: type)
                })
            })
        }
        return (items, localItems)
    }

}
