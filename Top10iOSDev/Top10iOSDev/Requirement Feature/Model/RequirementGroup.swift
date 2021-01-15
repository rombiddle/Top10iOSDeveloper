//
//  RequirementGroup.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 09/01/2021.
//

import Foundation

/// ex: Design patterns
public struct RequirementGroup {
    public let id: UUID
    public let name: String
    public let items: [RequirementItem]
    
    public init(id: UUID, name: String, items: [RequirementItem]) {
        self.id = id
        self.name = name
        self.items = items
    }
}

extension RequirementGroup: Equatable {
    public static func == (lhs: RequirementGroup, rhs: RequirementGroup) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.items == rhs.items
    }
}
