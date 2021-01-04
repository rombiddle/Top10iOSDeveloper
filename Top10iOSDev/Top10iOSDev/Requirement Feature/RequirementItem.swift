//
//  RequirementItem.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/01/2021.
//

import Foundation

struct RequirementCategory {
    let id: UUID
    let name: String
    let groups: [RequirementGroup]
}

struct RequirementGroup {
    let id: UUID
    let name: String
    let items: [RequirementItem]
}

struct RequirementItem {
    let id: UUID
    let name: String
    let type: RequirementType
}

enum RequirementType {
    case level(Int?)
    case done(Bool?)
    case number(Int?, String?)
}
