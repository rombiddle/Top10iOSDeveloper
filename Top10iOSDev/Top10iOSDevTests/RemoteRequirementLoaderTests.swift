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
                
        XCTAssertNil(client.requestedURL)
    }
    
    func test_init_RequestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
                
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteRequirementLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteRequirementLoader(url: url, client: client)
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }

}
