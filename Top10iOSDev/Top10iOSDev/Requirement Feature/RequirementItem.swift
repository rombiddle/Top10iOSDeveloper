//
//  RequirementItem.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/01/2021.
//

import Foundation

/// ex: Adapter pattern
public struct RequirementItem {
    let id: UUID
    let name: String
    let type: RequirementType
}

extension RequirementItem: Equatable {
    public static func == (lhs: RequirementItem, rhs: RequirementItem) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.type == rhs.type
    }
}

enum RequirementType {
    case level(Int?)
    case done(Bool?)
    case number(Int?, String?)
    
    var requirementCode: Int {
        switch self {
        case .level: return 0
        case .done: return 1
        case .number: return 2
        }
    }
}

extension RequirementType: Equatable {
    public static func == (lhs: RequirementType, rhs: RequirementType) -> Bool {
        switch (lhs, rhs) {
        case (let .level(rhsLevel), let .level(lhsLevel)):
            return rhsLevel == lhsLevel
        case (let .done(rhsDone), let .done(lhsDone)):
            return rhsDone == lhsDone
        case (let .number(rhsInt, rhsString), let .number(lhsInt, lhsSting)):
            return (rhsInt, rhsString) == (lhsInt, lhsSting)
        default:
            return false
        }
    }
}
    
