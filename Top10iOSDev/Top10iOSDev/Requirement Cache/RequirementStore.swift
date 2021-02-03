//
//  RequirementStore.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 02/02/2021.
//

import Foundation

public protocol RequirementStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func insert(_ items: [LocalRequirementCategory], completion: @escaping InsertionCompletion)
    func deleteCachedRequirements(completion: @escaping DeletionCompletion)
}

public struct LocalRequirementCategory: Equatable {
    public let id: UUID
    public let name: String
    public let groups: [LocalRequirementGroup]
    
    public init(id: UUID, name: String, groups: [LocalRequirementGroup]) {
        self.id = id
        self.name = name
        self.groups = groups
    }
}

public struct LocalRequirementGroup: Equatable {
    public let id: UUID
    public let name: String
    public let items: [LocalRequirementItem]
    
    public init(id: UUID, name: String, items: [LocalRequirementItem]) {
        self.id = id
        self.name = name
        self.items = items
    }
}

public struct LocalRequirementItem: Equatable {
    public let id: UUID
    public let name: String
    public let type: LocalRequirementType
    
    public init(id: UUID, name: String, type: LocalRequirementType) {
        self.id = id
        self.name = name
        self.type = type
    }
}

public enum LocalRequirementType: Equatable {
    case level(Int?)
    case done(Bool?)
    case number(Int?, String?)
    
    init(type: Int) {
        switch type {
        case 0: self = .level(nil)
        case 1: self = .done(nil)
        default: self = .number(nil, nil)
        }
    }
}
