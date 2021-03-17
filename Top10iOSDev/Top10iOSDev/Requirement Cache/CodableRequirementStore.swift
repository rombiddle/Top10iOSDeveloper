//
//  CodableRequirementStore.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 12/02/2021.
//

import Foundation

public class CodableRequirementStore: RequirementStore {
    private let storeURL: URL
    private let queue = DispatchQueue(label: "\(CodableRequirementStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let storeURL = self.storeURL
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
                return completion(.success(.none))
            }
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([CodableRequirementCategory].self, from: data)
                completion(.success(CachedRequirements(requirements: decoded.map { $0.local })))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ items: [LocalRequirementCategory], completion: @escaping InsertionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            do {
                let encoder = JSONEncoder()
                let requirements = items.map { CodableRequirementCategory($0) }
                let encoded = try encoder.encode(requirements)
                try encoded.write(to: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func deleteCachedRequirements(completion: @escaping DeletionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            guard FileManager.default.fileExists(atPath: storeURL.path) else {
                return completion(nil)
            }

            do {
                try FileManager.default.removeItem(at: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }

    private struct CodableRequirementCategory: Equatable, Codable {
        private let id: UUID
        private let name: String
        private let groups: [CodaleRequirementGroup]
        
        init(_ requirement: LocalRequirementCategory) {
            self.id = requirement.id
            self.name = requirement.name
            self.groups = requirement.groups.map { CodaleRequirementGroup($0) }
        }
        
        var local: LocalRequirementCategory {
            LocalRequirementCategory(id: self.id, name: self.name, groups: self.groups.map { $0.local })
        }
    }
    
    private struct CodaleRequirementGroup: Equatable, Codable {
        private let id: UUID
        private let name: String
        private let items: [CodableRequirementItem]
        
        init(_ group: LocalRequirementGroup) {
            self.id = group.id
            self.name = group.name
            self.items = group.items.map { CodableRequirementItem($0) }
        }
        
        var local: LocalRequirementGroup {
            LocalRequirementGroup(id: self.id, name: self.name, items: self.items.map { $0.local })
        }
    }
    
    private struct CodableRequirementItem: Equatable, Codable {
        private let id: UUID
        private let name: String
        private let type: CodableRequirementType
        
        init(_ item: LocalRequirementItem) {
            self.id = item.id
            self.name = item.name
            self.type = CodableRequirementType(rawValue: item.type.rawValue) ?? .unknown
        }
        
        var local: LocalRequirementItem {
            LocalRequirementItem(id: self.id, name: self.name, type: self.type.local)
        }
    }
    
    private enum CodableRequirementType: String, Equatable, Codable {
        case level
        case done
        case number
        case unknown
        
        var local: LocalRequirementType {
            LocalRequirementType(rawValue: self.rawValue) ?? .unknown
        }
    }
}
