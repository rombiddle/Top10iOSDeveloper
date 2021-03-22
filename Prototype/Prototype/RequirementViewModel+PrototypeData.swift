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
            RequirementViewModel(title: "CI / CD", totalItems: 2, completedItems: 5),
            RequirementViewModel(title: "Software Architecture", totalItems: 1, completedItems: 3),
            RequirementViewModel(title: "Versionning", totalItems: 1, completedItems: 2),
            RequirementViewModel(title: "Dependency Manger", totalItems: 1, completedItems: 3),
            RequirementViewModel(title: "OOP", totalItems: 1, completedItems: 10),
            RequirementViewModel(title: "Software Design", totalItems: 3, completedItems: 7)
        ]
    }
}
