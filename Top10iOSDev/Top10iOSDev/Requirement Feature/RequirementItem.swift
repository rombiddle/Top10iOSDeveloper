//
//  RequirementItem.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/01/2021.
//

import Foundation

/// ex: Adapter pattern
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
