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
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ items: [LocalRequirementCategory], completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedRequirements(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}
