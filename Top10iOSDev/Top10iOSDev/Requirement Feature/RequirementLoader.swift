//
//  RequirementLoader.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/01/2021.
//

import Foundation

enum LoadRequirementResult {
    case success([RequirementCategory])
    case error(Error)
}

protocol RequirementLoader {
    func load(completion: @escaping (LoadRequirementResult) -> Void)
}
