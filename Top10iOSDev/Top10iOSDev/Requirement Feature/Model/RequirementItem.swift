//
//  RequirementItem.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/01/2021.
//

import Foundation

/// ex: Adapter pattern
public struct RequirementItem: Equatable {
    public let id: UUID
    public let name: String
    public let type: RequirementType
    
    public init(id: UUID, name: String, type: RequirementType) {
        self.id = id
        self.name = name
        self.type = type
    }
}
