//
//  RemoteRequirementCategory.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/02/2021.
//

import Foundation

internal struct RemoteRequirementCategory: Decodable {
    internal let id: UUID
    internal let name: String
    internal let groups: [RemoteRequirementGroup]
}
