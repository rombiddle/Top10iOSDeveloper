//
//  RequirementCategoryMapper.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 15/01/2021.
//

import Foundation

internal struct RemoteRequirementCategory: Decodable {
    internal let id: UUID
    internal let name: String
    internal let groups: [RemoteRequirementGroup]
}

internal struct RemoteRequirementGroup: Decodable {
    internal let id: UUID
    internal let name: String
    internal let items: [RemoteRequirementItem]
}

internal struct RemoteRequirementItem: Decodable {
    internal let id: UUID
    internal let name: String
    internal let type: Int
}

internal final class RequirementCategoryMapper {
    private struct Root: Decodable {
        let categories: [RemoteRequirementCategory]
    }
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteRequirementCategory] {
        guard response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteRequirementLoader.Error.invalidData
        }
        
        return root.categories
    }
}
