//
//  LocalRequirementLoader.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 02/02/2021.
//

import Foundation

public final class LocalRequirementLoader {
    private let store: RequirementStore
    
    public typealias SaveResult = Error?
    
    public init(store: RequirementStore) {
        self.store = store
    }
    
    public func save(_ items: [RequirementCategory], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedRequirements { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        }
    }
    
    private func cache(_ items: [RequirementCategory], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}
