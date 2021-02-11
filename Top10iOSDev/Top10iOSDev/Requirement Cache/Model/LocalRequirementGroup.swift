//
//  LocalRequirementGroup.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/02/2021.
//

import Foundation

public struct LocalRequirementGroup: Equatable, Codable {
    public let id: UUID
    public let name: String
    public let items: [LocalRequirementItem]
    
    public init(id: UUID, name: String, items: [LocalRequirementItem]) {
        self.id = id
        self.name = name
        self.items = items
    }
}
