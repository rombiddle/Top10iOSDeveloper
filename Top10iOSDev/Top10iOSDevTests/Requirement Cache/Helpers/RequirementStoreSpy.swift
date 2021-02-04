//
//  RequirementStoreSpy.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 04/02/2021.
//

import Foundation
import Top10iOSDev

class RequirementStoreSpy: RequirementStore {
    enum ReceivedMessage: Equatable {
        case deleteCachedRequirements
        case insert([LocalRequirementCategory])
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    
    func deleteCachedRequirements(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCachedRequirements)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func insert(_ items: [LocalRequirementCategory], completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(items))
    }
    
    func retrieve() {
        receivedMessages.append(.retrieve)
    }
}
