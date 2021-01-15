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
