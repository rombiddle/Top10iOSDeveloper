//
//  RemoteRequirementLoader.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 04/01/2021.
//

import Foundation

public final class RemoteRequirementLoader: RequirementLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadRequirementResult
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(RequirementCategoryMapper.map(data, from: response))
        
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
