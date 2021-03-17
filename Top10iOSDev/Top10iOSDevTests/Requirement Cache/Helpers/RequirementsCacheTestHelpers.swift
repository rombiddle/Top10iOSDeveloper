//
//  RequirementsCacheTestHelpers.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 05/02/2021.
//

import Foundation
import Top10iOSDev

func uniqueItem() -> RequirementCategory {
    let items = [RequirementItem(id: UUID(), name: "any", type: .done)]
    let groups = [RequirementGroup(id: UUID(), name: "any", items: items)]
    return RequirementCategory(id: UUID(), name: "any", groups: groups)
}

func uniqueItems() -> (models: [RequirementCategory], locals: [LocalRequirementCategory]) {
    let items = [uniqueItem(), uniqueItem()]
    let localItems = items.map { cat in
        return LocalRequirementCategory(id: cat.id, name: cat.name, groups: cat.groups.map { group in
            return LocalRequirementGroup(id: group.id, name: group.name, items: group.items.map { item in
                let type = LocalRequirementType(rawValue: item.type.rawValue) ?? .unknown
                return LocalRequirementItem(id: item.id, name: item.name, type: type)
            })
        })
    }
    return (items, localItems)
}
