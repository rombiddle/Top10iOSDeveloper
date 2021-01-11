//
//  RequirementCategory.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 09/01/2021.
//

import Foundation

/// ex: Software architecture
public struct RequirementCategory {
    let id: UUID
    let name: String
    let groups: [RequirementGroup]
}

extension RequirementCategory: Equatable {
    public static func == (lhs: RequirementCategory, rhs: RequirementCategory) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.groups == rhs.groups
    }
}
