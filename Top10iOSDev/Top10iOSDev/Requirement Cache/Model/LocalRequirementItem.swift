//
//  LocalRequirementItem.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/02/2021.
//

import Foundation

public struct LocalRequirementItem: Equatable, Encodable {
    public let id: UUID
    public let name: String
    public let type: LocalRequirementType
    
    public init(id: UUID, name: String, type: LocalRequirementType) {
        self.id = id
        self.name = name
        self.type = type
    }
}
