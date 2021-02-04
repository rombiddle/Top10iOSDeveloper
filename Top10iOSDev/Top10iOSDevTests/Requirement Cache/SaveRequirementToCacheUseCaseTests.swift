//
//  CacheFeedUseCaseTests.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 25/01/2021.
//

import XCTest
import Top10iOSDev

class SaveRequirementToCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        
        sut.save(uniqueItems().models) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRequirements])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(uniqueItems().models) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRequirements])
    }
    
    func test_save_requestNewCacheInsertionOnSuccessfulDeletion() {
        let (sut, store) = makeSUT()
        let items = uniqueItems()
        
        sut.save(items.models) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedRequirements, .insert(items.locals)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
    
        expect(sut, toCompleteWithError: deletionError) {
            store.completeDeletion(with: deletionError)
        }
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWithError: insertionError) {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        }
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: nil) {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        }
    }
    
    func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = RequirementStoreSpy()
        var sut: LocalRequirementLoader? = LocalRequirementLoader(store: store)
        
        var receivedResult = [LocalRequirementLoader.SaveResult]()
        sut?.save(uniqueItems().models, completion: { receivedResult.append($0) })
        
        sut = nil
        store.completeDeletion(with: anyNSError())

        XCTAssertTrue(receivedResult.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = RequirementStoreSpy()
        var sut: LocalRequirementLoader? = LocalRequirementLoader(store: store)
        
        var receivedResult = [LocalRequirementLoader.SaveResult]()
        sut?.save(uniqueItems().models, completion: { receivedResult.append($0) })
        
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())

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
    
    private func expect(_ sut: LocalRequirementLoader, toCompleteWithError expectedError: NSError?, action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save(uniqueItems().models) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
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
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }

}
