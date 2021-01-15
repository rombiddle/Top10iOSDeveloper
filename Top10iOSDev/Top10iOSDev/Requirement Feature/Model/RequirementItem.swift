//
//  RequirementItem.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/01/2021.
//

import Foundation

/// ex: Adapter pattern
public struct RequirementItem {
    public let id: UUID
    public let name: String
    public let type: RequirementType
    
    public init(id: UUID, name: String, type: RequirementType) {
        self.id = id
        self.name = name
        self.type = type
    }
}

extension RequirementItem: Equatable {
    public static func == (lhs: RequirementItem, rhs: RequirementItem) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.type == rhs.type
    }
}

extension RequirementItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, name, type
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        let rawValue = try container.decode(Int.self, forKey: .type)
        if let requirementType = RequirementType(type: rawValue) {
            type = requirementType
        } else {
            throw CodingError.unknownValue
        }
    }
}
