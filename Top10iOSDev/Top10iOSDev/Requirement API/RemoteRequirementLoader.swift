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
    
    public typealias Result = RequirementLoader.Result
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(RemoteRequirementLoader.map(data, from: response))
        
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try RequirementCategoryMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteRequirementCategory {
    func toModels() -> [RequirementCategory] {
        map {
            RequirementCategory(id: $0.id, name: $0.name, groups: $0.groups.toModels())
        }
    }
}

private extension Array where Element == RemoteRequirementGroup {
    func toModels() -> [RequirementGroup] {
        map {
            RequirementGroup(id: $0.id, name: $0.name, items: $0.items.toModels())
        }
    }
}

private extension Array where Element == RemoteRequirementItem {
    func toModels() -> [RequirementItem] {
        map {
            RequirementItem(id: $0.id, name: $0.name, type: RequirementType.init(rawValue: $0.type) ?? .unknown)
        }
    }
}
