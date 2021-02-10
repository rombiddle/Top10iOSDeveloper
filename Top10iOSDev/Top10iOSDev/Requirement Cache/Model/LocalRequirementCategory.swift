//
//  LocalRequirementCategory.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/02/2021.
//

import Foundation

public struct LocalRequirementCategory: Equatable, Encodable {
    public let id: UUID
    public let name: String
    public let groups: [LocalRequirementGroup]
    
    public init(id: UUID, name: String, groups: [LocalRequirementGroup]) {
        self.id = id
        self.name = name
        self.groups = groups
    }
}
