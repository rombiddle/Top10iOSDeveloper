//
//  RequirementGroup.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 09/01/2021.
//

import Foundation

/// ex: Design patterns
public struct RequirementGroup {
    let id: UUID
    let name: String
    let items: [RequirementItem]
}

extension RequirementGroup: Equatable {
    public static func == (lhs: RequirementGroup, rhs: RequirementGroup) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.items == rhs.items
    }
}
