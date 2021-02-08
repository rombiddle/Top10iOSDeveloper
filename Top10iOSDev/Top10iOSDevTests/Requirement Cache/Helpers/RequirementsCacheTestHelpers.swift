//
//  RequirementsCacheTestHelpers.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 05/02/2021.
//

import Foundation
import Top10iOSDev

func uniqueItem() -> RequirementCategory {
    let items = [RequirementItem(id: UUID(), name: "any", type: .done(true))]
    let groups = [RequirementGroup(id: UUID(), name: "any", items: items)]
    return RequirementCategory(id: UUID(), name: "any", groups: groups)
}

func uniqueItems() -> (models: [RequirementCategory], locals: [LocalRequirementCategory]) {
    let items = [uniqueItem(), uniqueItem()]
    let localItems = items.map { cat in
        return LocalRequirementCategory(id: cat.id, name: cat.name, groups: cat.groups.map { group in
            return LocalRequirementGroup(id: group.id, name: group.name, items: group.items.map { item in
                var type: LocalRequirementType = .done(true)
                switch item.type {
                case let .done(isDone): type = LocalRequirementType.done(isDone)
                case let .level(myLevel): type = LocalRequirementType.level(myLevel)
                case let .number(myNb, myTitle): type = LocalRequirementType.number(myNb, myTitle)
                }
                return LocalRequirementItem(id: item.id, name: item.name, type: type)
            })
        })
    }
    return (items, localItems)
}
