//
//  RequirementLoader.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/01/2021.
//

import Foundation

public typealias LoadRequirementResult = Result<[RequirementCategory], Error>

public protocol RequirementLoader {
    func load(completion: @escaping (LoadRequirementResult) -> Void)
}
