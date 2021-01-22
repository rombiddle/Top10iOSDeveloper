//
//  RemoteRequirementLoader.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 03/01/2021.
//

import XCTest
import Top10iOSDev

class RemoteRequirementLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let (_, client) = makeSUT(url: url)
                
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_RequestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
                
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_RequestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
                
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData)) {
                let json = makeCategoriesJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData)) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJSON = makeCategoriesJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        // first case (empty groups)
        let cat1 = makeCategory(id: UUID(), name: "cat name", groups: [])
        
        // 2nd case (done)
        let item2 = makeItem(id: UUID(), name: "item name", type: .done(nil))
        let group2 = makeGroup(id: UUID(), name: "group name", items: [item2])
        let cat2 = makeCategory(id: UUID(), name: "another cat name", groups: [group2])
        
        // 3rd case (level)
        let item3 = makeItem(id: UUID(), name: "item name", type: .level(nil))
        let group3 = makeGroup(id: UUID(), name: "group name", items: [item3])
        let cat3 = makeCategory(id: UUID(), name: "another cat name", groups: [group3])
        
        // 4th case (number)
        let item4 = makeItem(id: UUID(), name: "item name", type: .number(nil, nil))
        let group4 = makeGroup(id: UUID(), name: "group name", items: [item4])
        let cat4 = makeCategory(id: UUID(), name: "another cat name", groups: [group4])
        
        expect(sut, toCompleteWith: .success([cat1.model, cat2.model, cat3.model, cat4.model])) {
            let json = makeCategoriesJSON([cat1.json, cat2.json, cat3.json, cat4.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    func test_load_deliversItemsWithNumberTypeOn200HTTPRespnseWithJSONItemsWithUnknownTypeItem() {
        let (sut, client) = makeSUT()
        
        let item = makeItem(id: UUID(), name: "item name", type: .number(nil, nil))
        let group = makeGroup(id: UUID(), name: "group name", items: [item])
        let cat = makeCategory(id: UUID(), name: "another cat name", groups: [group])
        let json = jsonValue(for: cat.model)
        
        expect(sut, toCompleteWith: .success([cat.model])) {
            let json = makeCategoriesJSON([json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDealocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteRequirementLoader? = RemoteRequirementLoader(url: url, client: client)
        
        var capturedResults = [RemoteRequirementLoader.Result]()
        sut?.load { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, data: makeCategoriesJSON([]))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteRequirementLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteRequirementLoader(url: url, client: client)
        
        trackForMemotyLeaks(sut)
        trackForMemotyLeaks(client)
        
        return (sut, client)
    }
    
    private func failure(_ error: RemoteRequirementLoader.Error) -> RemoteRequirementLoader.Result {
        .failure(error)
    }
    
    private func makeCategory(id: UUID, name: String, groups: [RequirementGroup]) -> (model: RequirementCategory, json: [String: Any]) {
        let item = RequirementCategory(id: id, name: name, groups: groups)
        let json = jsonValue(for: item)
        
        return (item, json)
    }
    
    private func makeGroup(id: UUID, name: String, items: [RequirementItem]) -> RequirementGroup {
        RequirementGroup(id: id,
                         name: name,
                         items: items)
    }
    
    private func makeItem(id: UUID, name: String, type: RequirementType) -> RequirementItem {
        RequirementItem(id: id,
                        name: name,
                        type: type)
    }
    
    private func jsonValue(for item: RequirementCategory) -> [String: Any] {
        [
            "id": item.id.uuidString,
            "name": item.name,
            "groups": item.groups.map { group in
                return [
                    "id": group.id.uuidString,
                    "name": group.name,
                    "items": group.items.map { item in
                        return [
                            "id": item.id.uuidString,
                            "name": item.name,
                            "type": item.type.typeId
                        ] as [String: Any]
                    }
                ] as [String: Any]
            }
        ] as [String: Any]
    }
    
    private func makeCategoriesJSON(_ cats: [[String: Any]]) -> Data {
        let json = ["categories": cats]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteRequirementLoader, toCompleteWith expectedResult: RemoteRequirementLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteRequirementLoader.Error), .failure(expectedError as RemoteRequirementLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index],
                                           statusCode: code,
                                           httpVersion: nil,
                                           headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
    
    private func anyInt() -> Int {
        Int.random(in: RequirementType.allCases.count..<100)
    }

}
