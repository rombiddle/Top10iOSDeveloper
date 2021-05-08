//
//  RequirementsViewController.swift
//  Top10iOSDeviOSTests
//
//  Created by Romain Brunie on 22/03/2021.
//

import XCTest
import UIKit
import Top10iOSDev

final class RequirementsViewController: UIViewController {
    
}

class RequirementsViewControllerTests: XCTestCase {
    
    func test_loadRequirements_requestRequirementsFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadRequirementsCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadRequirementsCallCount, 1, "Expected a loading request once view is loaded")
    }
    
    // MARK: - Helpers
        
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RequirementsViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = RequirementsViewController(requirementsLoader: loader, imageLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader, FeedImageDataLoader {
        // MARK: - FeedLoader
        private var RequirementRequests = [(RequirementLoader.Result) -> Void]()
        
        var loadRequirementsCallCount: Int {
            return RequirementRequests.count
        }
        
        func load(completion: @escaping (RequirementLoader.Result) -> Void) {
            RequirementRequests.append(completion)
        }
        
        func completeRequirementsLoading(with requirements: [RequirementCategory] = [], at index: Int = 0) {
            RequirementRequests[index](.success(RequirementCategory))
        }
        
        func completeRequirementsLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            RequirementRequests[index](.failure(error))
        }
    }

//    func test_viewDidAppear_showsRequirementsFilling() {
//        let sut = RequirementsViewController()
//
//        sut.beginAppearanceTransition(true, animated: true)
//        sut.endAppearanceTransition()
//
//        XCTAssertEqual(sut.)
//    }

}
