//
//  RequirementItem.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/01/2021.
//

import Foundation

/// ex: Adapter pattern
public struct RequirementItem: Decodable {
    public let id: UUID
    public let name: String
    public let type: RequirementType
    
    public init(id: UUID, name: String, type: RequirementType) {
        self.id = id
        self.name = name
        self.type = type
    }
}

extension RequirementItem: Equatable {
    public static func == (lhs: RequirementItem, rhs: RequirementItem) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.type == rhs.type
    }
}

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

extension RequirementType: Decodable {
    enum Key: CodingKey {
        case rawValue
    }
        
    enum CodingError: Error {
        case unknownValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        
        if let type = RequirementType(type: rawValue) {
            self = type
        } else {
            throw CodingError.unknownValue
        }
    }
}
    
