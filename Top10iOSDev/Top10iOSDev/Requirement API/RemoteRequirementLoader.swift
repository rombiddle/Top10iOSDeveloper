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
            case let .success(data, response):
                do {
                    let categories = try RequirementCategoryMapper.map(data, response)
                    completion(.success(categories))
                } catch {
                    completion(.failure(.invalidData))
                }
        
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private class RequirementCategoryMapper {
    private struct Root: Decodable {
        let categories: [Category]
    }

    private struct Category: Decodable {
        let id: UUID
        let name: String
        let groups: [Group]
        
        var category: RequirementCategory {
            RequirementCategory(id: id,
                                name: name,
                                groups: groups.map { $0.group })
        }
    }

    private struct Group: Decodable {
        let id: UUID
        let name: String
        let items: [Item]
        
        var group: RequirementGroup {
            RequirementGroup(id: id,
                             name: name,
                             items: items.compactMap { $0.item })
        }
    }

    private struct Item: Decodable {
        let id: UUID
        let name: String
        let type: Int
        
        var item: RequirementItem? {
            if let rType = RequirementType(type: type) {
                return RequirementItem(id: id,
                                       name: name,
                                       type: rType)
            } else {
                return nil
            }
        }
    }

    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RequirementCategory] {
        guard response.statusCode == 200 else {
            throw RemoteRequirementLoader.Error.invalidData
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.categories.map { $0.category }
    }
}
