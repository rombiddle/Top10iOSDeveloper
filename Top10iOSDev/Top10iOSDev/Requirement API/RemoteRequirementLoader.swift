//
//  RemoteRequirementLoader.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 04/01/2021.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL)
}

public final class RemoteRequirementLoader {
    private let client: HTTPClient
    private let url: URL
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load() {
        client.get(from: url)
    }
}
