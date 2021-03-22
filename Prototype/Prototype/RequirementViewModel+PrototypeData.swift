//
//  RequirementViewModel+PrototypeData.swift
//  Prototype
//
//  Created by Romain Brunie on 22/03/2021.
//

import Foundation

extension RequirementViewModel {
    static var prototypeRequirements: [RequirementViewModel] {
        return [
            RequirementViewModel(title: "CI / CD", totalItems: 5, completedItems: 2),
            RequirementViewModel(title: "Software Architecture", totalItems: 3, completedItems: 1),
            RequirementViewModel(title: "Versionning", totalItems: 2, completedItems: 1),
            RequirementViewModel(title: "Dependency Manger", totalItems: 3, completedItems: 1),
            RequirementViewModel(title: "OOP", totalItems: 10, completedItems: 1),
            RequirementViewModel(title: "Software Design", totalItems: 7, completedItems: 3)
        ]
    }
}
