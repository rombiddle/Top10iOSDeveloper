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
    public typealias LoadResult = LoadRequirementResult
    
    public init(store: RequirementStore) {
        self.store = store
    }
}

extension LocalRequirementLoader {
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
        store.insert(items.toLocals()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}

extension LocalRequirementLoader {
    public func load(with completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case let .found(requirements):
                completion(.success(requirements.toModels()))
                
            case .empty:
                completion(.success([]))
            }
        }
    }
}
 
extension LocalRequirementLoader {
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCachedRequirements { _ in }
                
            case .found, .empty:
                break
            }
        }
    }
}

private extension Array where Element == RequirementCategory {
    func toLocals() -> [LocalRequirementCategory] {
        map {
            LocalRequirementCategory(id: $0.id, name: $0.name, groups: $0.groups.toLocals())
        }
    }
}

private extension Array where Element == RequirementGroup {
    func toLocals() -> [LocalRequirementGroup] {
        map {
            LocalRequirementGroup(id: $0.id, name: $0.name, items: $0.items.toLocals())
        }
    }
}

private extension Array where Element == RequirementItem {
    func toLocals() -> [LocalRequirementItem] {
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

private extension Array where Element == LocalRequirementCategory {
    func toModels() -> [RequirementCategory] {
        map {
            RequirementCategory(id: $0.id, name: $0.name, groups: $0.groups.toModels())
        }
    }
}

private extension Array where Element == LocalRequirementGroup {
    func toModels() -> [RequirementGroup] {
        map {
            RequirementGroup(id: $0.id, name: $0.name, items: $0.items.toModels())
        }
    }
}

private extension Array where Element == LocalRequirementItem {
    func toModels() -> [RequirementItem] {
        map {
            RequirementItem(id: $0.id, name: $0.name, type: $0.type.toModel())
        }
    }
}

private extension LocalRequirementType {
    func toModel() -> RequirementType {
        switch self {
        case let .done(isDone):
            return RequirementType.done(isDone)
        case let .level(myLevel):
            return RequirementType.level(myLevel)
        case let .number(myNb, myTitle):
            return RequirementType.number(myNb, myTitle)
        }
    }
}
