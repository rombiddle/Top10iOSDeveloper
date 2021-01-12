//
//  RemoteRequirementLoader.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 04/01/2021.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteRequirementLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([RequirementCategory])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, _):
                if let _ = try? JSONSerialization.jsonObject(with: data) {
                    if let root = try? JSONDecoder().decode(Root.self, from: data) {
                        completion(.success(root.categories))
                    }
                } else {
                    completion(.failure(.invalidData))
                }
        
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private struct Root: Decodable {
    let categories: [RequirementCategory]
}
