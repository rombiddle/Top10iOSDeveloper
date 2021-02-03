//
//  LocalRequirementType.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/02/2021.
//

import Foundation

public enum LocalRequirementType: Equatable {
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
