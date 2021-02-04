//
//  RequirementStore.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 02/02/2021.
//

import Foundation

public enum RetrieveCachedRequirementResult {
    case empty
    case found(requirements: [LocalRequirementCategory])
    case failure(Error)
}

public protocol RequirementStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedRequirementResult) -> Void
    
    func insert(_ items: [LocalRequirementCategory], completion: @escaping InsertionCompletion)
    func deleteCachedRequirements(completion: @escaping DeletionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
