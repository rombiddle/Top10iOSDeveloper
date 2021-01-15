//
//  RequirementType.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 13/01/2021.
//

import Foundation

public enum RequirementType {
    case level(Int?)
    case done(Bool?)
    case number(Int?, String?)
    
    init?(type: Int) {
        switch type {
        case 0: self = .level(nil)
        case 1: self = .done(nil)
        default: self = .number(nil, nil)
        }
    }
    
    public var typeId: Int {
        switch self {
        case .level: return 0
        case .done: return 1
        default: return 2
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
