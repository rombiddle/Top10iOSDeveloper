//
//  RequirementLoader.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/01/2021.
//

import Foundation

public protocol RequirementLoader {
    typealias Result = Swift.Result<[RequirementCategory], Error>
    
    func load(completion: @escaping (Result) -> Void)
}
