//
//  RequirementCategory.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 09/01/2021.
//

import Foundation

/// ex: Software architecture
public struct RequirementCategory: Equatable {
    public let id: UUID
    public let name: String
    public let groups: [RequirementGroup]
    
    public init(id: UUID, name: String, groups: [RequirementGroup]) {
        self.id = id
        self.name = name
        self.groups = groups
    }
}
