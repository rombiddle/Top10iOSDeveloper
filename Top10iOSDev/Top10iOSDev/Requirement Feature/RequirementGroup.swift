//
//  RequirementGroup.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 09/01/2021.
//

import Foundation

/// ex: Design patterns
struct RequirementGroup {
    let id: UUID
    let name: String
    let items: [RequirementItem]
}
