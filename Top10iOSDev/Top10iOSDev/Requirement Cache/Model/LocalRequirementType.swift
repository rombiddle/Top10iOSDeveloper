//
//  LocalRequirementType.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/02/2021.
//

import Foundation

public enum LocalRequirementType: String, Equatable, Encodable {
    case level
    case done
    case number
    case unknown
}
