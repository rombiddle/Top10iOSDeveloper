//
//  RequirementCategoryMapper.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 15/01/2021.
//

import Foundation

internal final class RequirementCategoryMapper {
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
    
    private static var OK_200: Int { return 200 }

    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [RequirementCategory] {
        guard response.statusCode == OK_200 else {
            throw RemoteRequirementLoader.Error.invalidData
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.categories.map { $0.category }
    }
}
