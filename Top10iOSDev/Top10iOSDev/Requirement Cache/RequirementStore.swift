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
    
    func insert(_ items: [RequirementCategory], completion: @escaping InsertionCompletion)
    func deleteCachedRequirements(completion: @escaping DeletionCompletion)
}
