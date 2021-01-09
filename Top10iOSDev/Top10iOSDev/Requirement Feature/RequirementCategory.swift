//
//  RequirementCategory.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 09/01/2021.
//

import Foundation

/// ex: Software architecture
struct RequirementCategory {
    let id: UUID
    let name: String
    let groups: [RequirementGroup]
}
