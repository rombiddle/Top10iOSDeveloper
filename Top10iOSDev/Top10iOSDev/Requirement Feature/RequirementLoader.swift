//
//  RequirementLoader.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/01/2021.
//

import Foundation

public enum LoadRequirementResult {
    case success([RequirementCategory])
    case failure(Error)
}

protocol RequirementLoader {
    func load(completion: @escaping (LoadRequirementResult) -> Void)
}
