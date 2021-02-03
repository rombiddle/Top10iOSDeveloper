//
//  RequirementType.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 13/01/2021.
//

import Foundation

public enum RequirementType: Equatable {
    case level(Int?)
    case done(Bool?)
    case number(Int?, String?)
    
    init(type: Int) {
        switch type {
        case 0: self = .level(nil)
        case 1: self = .done(nil)
        default: self = .number(nil, nil)
        }
    }
}
