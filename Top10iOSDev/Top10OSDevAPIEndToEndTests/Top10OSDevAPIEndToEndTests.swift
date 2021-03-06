//
//  Top10OSDevAPIEndToEndTests.swift
//  Top10OSDevAPIEndToEndTests
//
//  Created by Romain Brunie on 21/01/2021.
//

import XCTest
import Top10iOSDev

class Top10OSDevAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGetRequirementResult_matchesFixedTestAccountData() {
        switch getRequirementResult() {
        case let .success(requirements)?:
            let groups = requirements.flatMap({ $0.groups })
            let items = groups.flatMap({ $0.items })
            
            XCTAssertEqual(requirements.count, 2)
            XCTAssertEqual(groups.count, 3)
            XCTAssertEqual(items.count, 6)
            XCTAssertEqual(requirements, expectedRequirements())
            
        case let .failure(error)?:
            XCTFail("Expected successful requirements result, got \(error) instead")
            
        default:
            XCTFail("Expected successful requirements result, got no instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getRequirementResult(file: StaticString = #filePath, line: UInt = #line) -> RequirementLoader.Result? {
        let testServerURL = URL(string: "https://raw.githubusercontent.com/rombiddle/Top10iOSDeveloper/feature/add-cache-module/requirements.json")!
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteRequirementLoader(url: testServerURL, client: client)
        trackForMemotyLeaks(client, file: file, line: line)
        trackForMemotyLeaks(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: RequirementLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3.0)
        
        return receivedResult
    }
    
    private func expectedRequirements() -> [RequirementCategory] {
        [expectedRequirementFirstCategory(), expectedRequirementSecondCategory()]
    }
    
    private func expectedRequirementFirstCategory() -> RequirementCategory {
        let itemsGroup1 = [
            RequirementItem(id: UUID(uuidString: "656bf1ff-173f-427a-b898-9acbd1de93a7")!, name: "Test Item 1.1", type: .level),
            RequirementItem(id: UUID(uuidString: "b53d59e9-0e52-4f72-bbe1-9ec128008233")!, name: "Test Item 1.2", type: .done)
        ]
        
        let itemsGroup2 = [
            RequirementItem(id: UUID(uuidString: "02af9317-1566-41c6-b6f2-3bf344a5e2a4")!, name: "Test Item 2.1", type: .number),
            RequirementItem(id: UUID(uuidString: "748a6ade-eb53-4606-86c4-322f1868d081")!, name: "Test Item 2.2", type: .unknown)
        ]
        
        let groups = [
            RequirementGroup(id: UUID(uuidString: "cf660f0b-3ebc-40bc-a6c4-c6d6ccf62bb5")!, name: "Test group 1", items: itemsGroup1),
            RequirementGroup(id: UUID(uuidString: "6154c267-a317-4844-8284-68db8315cf77")!, name: "Test group 2", items: itemsGroup2)
        ]
        
        return RequirementCategory(id: UUID(uuidString: "bf88e586-ca98-495a-a591-a925da8c3278")!, name: "Test category", groups: groups)
    }
    
    private func expectedRequirementSecondCategory() -> RequirementCategory {
        let itemsGroup = [
            RequirementItem(id: UUID(uuidString: "a0f83e61-09c7-40ee-a08c-c87b2968fdc9")!, name: "Test Item 2.1.1", type: .number),
            RequirementItem(id: UUID(uuidString: "5bfe62b9-5694-4f39-8fb1-c6f77850cc24")!, name: "Test Item 2.1.2", type: .level)
        ]
        
        let groups = [
            RequirementGroup(id: UUID(uuidString: "987aba07-947e-4f9a-9d65-1dff81d98c91")!, name: "Test group 2 from cat 2", items: itemsGroup)
        ]
        
        return RequirementCategory(id: UUID(uuidString: "300ab5f8-d958-4980-879c-86357fbacf90")!, name: "Test category 2", groups: groups)
    }

}
