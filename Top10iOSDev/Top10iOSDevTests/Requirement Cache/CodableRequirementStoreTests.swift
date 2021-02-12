//
//  CodableRequirementStoreTests.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 10/02/2021.
//

import XCTest
import Top10iOSDev

class CodableRequirementStore {
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func retrieve(completion: @escaping RequirementStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode([CodableRequirementCategory].self, from: data)
            completion(.found(requirements: decoded.map { $0.local }))
        } catch {
            completion(.failure(error))
        }
    }
    
    func insert(_ items: [LocalRequirementCategory], completion: @escaping RequirementStore.InsertionCompletion) {
        do {
            let encoder = JSONEncoder()
            let requirements = items.map { CodableRequirementCategory($0) }
            let encoded = try encoder.encode(requirements)
            try encoded.write(to: storeURL)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func deleteCachedRequirements(completion: @escaping RequirementStore.DeletionCompletion) {
        guard FileManager.default.fileExists(atPath: storeURL.path) else {
            return completion(nil)
        }

        try! FileManager.default.removeItem(at: storeURL)
        completion(nil)
    }

    private struct CodableRequirementCategory: Equatable, Codable {
        private let id: UUID
        private let name: String
        private let groups: [CodaleRequirementGroup]
        
        init(_ requirement: LocalRequirementCategory) {
            self.id = requirement.id
            self.name = requirement.name
            self.groups = requirement.groups.map { CodaleRequirementGroup($0) }
        }
        
        var local: LocalRequirementCategory {
            LocalRequirementCategory(id: self.id, name: self.name, groups: self.groups.map { $0.local })
        }
    }
    
    private struct CodaleRequirementGroup: Equatable, Codable {
        private let id: UUID
        private let name: String
        private let items: [CodableRequirementItem]
        
        init(_ group: LocalRequirementGroup) {
            self.id = group.id
            self.name = group.name
            self.items = group.items.map { CodableRequirementItem($0) }
        }
        
        var local: LocalRequirementGroup {
            LocalRequirementGroup(id: self.id, name: self.name, items: self.items.map { $0.local })
        }
    }
    
    private struct CodableRequirementItem: Equatable, Codable {
        private let id: UUID
        private let name: String
        private let type: CodableRequirementType
        
        init(_ item: LocalRequirementItem) {
            self.id = item.id
            self.name = item.name
            self.type = CodableRequirementType(rawValue: item.type.rawValue) ?? .unknown
        }
        
        var local: LocalRequirementItem {
            LocalRequirementItem(id: self.id, name: self.name, type: self.type.local)
        }
    }
    
    private enum CodableRequirementType: String, Equatable, Codable {
        case level
        case done
        case number
        case unknown
        
        var local: LocalRequirementType {
            LocalRequirementType(rawValue: self.rawValue) ?? .unknown
        }
    }
}

class CodableRequirementStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let requirements = uniqueItems().locals
        
        insert(requirements, to: sut)
        
        expect(sut, toRetrieve: .found(requirements: requirements))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let requirements = uniqueItems().locals
        
        insert(requirements, to: sut)
        
        expect(sut, toRetrieveTwice: .found(requirements: requirements))
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalidData".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieve: .failure(anyNSError()))
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalidData".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        
        let firstInsertionError = insert(uniqueItems().locals, to: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert cache successfully")
        
        let lastestRequirements = uniqueItems().locals
        let latestInsertionError = insert(lastestRequirements, to: sut)
        
        XCTAssertNil(latestInsertionError, "Expected to override cache successfully")
        expect(sut, toRetrieve: .found(requirements: lastestRequirements))
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        let requirements = uniqueItems().locals
        
        let insertionError = insert(requirements, to: sut)
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache deletion")

        sut.deleteCachedRequirements { deletionError in
            XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)

        expect(sut, toRetrieve: .empty)
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()
        insert(uniqueItems().locals, to: sut)

        let exp = expectation(description: "Wait for cache deletion")
        sut.deleteCachedRequirements { deletionError in
            XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)

        expect(sut, toRetrieve: .empty)
    }
    
    // - MARK: Helpers
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #filePath, line: UInt = #line) -> CodableRequirementStore {
        let sut = CodableRequirementStore(storeURL: storeURL ?? testSpecificStoreURL())
        trackForMemotyLeaks(sut, file: file, line: line)
        return sut
    }
    
    @discardableResult
    private func insert(_ requirements: [LocalRequirementCategory], to sut: CodableRequirementStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(requirements) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    private func expect(_ sut: CodableRequirementStore, toRetrieve expectedResult: RetrieveCachedRequirementResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty),
                 (.failure, .failure):
                break
                
            case let (.found(expected), .found(retrieved)):
                XCTAssertEqual(expected, retrieved)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: CodableRequirementStore, toRetrieveTwice expectedResult: RetrieveCachedRequirementResult, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }

}
