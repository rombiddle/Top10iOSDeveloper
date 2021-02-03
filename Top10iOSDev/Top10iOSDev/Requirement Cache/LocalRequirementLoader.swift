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
        store.insert(items.toLocal()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}

private extension Array where Element == RequirementCategory {
    func toLocal() -> [LocalRequirementCategory] {
        map {
            LocalRequirementCategory(id: $0.id, name: $0.name, groups: $0.groups.toLocal())
        }
    }
}

private extension Array where Element == RequirementGroup {
    func toLocal() -> [LocalRequirementGroup] {
        map {
            LocalRequirementGroup(id: $0.id, name: $0.name, items: $0.items.toLocal())
        }
    }
}

private extension Array where Element == RequirementItem {
    func toLocal() -> [LocalRequirementItem] {
        map {
            LocalRequirementItem(id: $0.id, name: $0.name, type: $0.type.toLocal())
        }
    }
}

private extension RequirementType {
    func toLocal() -> LocalRequirementType {
        switch self {
        case let .done(isDone):
            return LocalRequirementType.done(isDone)
        case let .level(myLevel):
            return LocalRequirementType.level(myLevel)
        case let .number(myNb, myTitle):
            return LocalRequirementType.number(myNb, myTitle)
        }
    }
}
