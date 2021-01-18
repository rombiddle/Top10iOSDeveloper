//
//  RequirementLoader.swift
//  Top10iOSDev
//
//  Created by Romain Brunie on 03/01/2021.
//

import Foundation

public enum LoadRequirementResult<Error: Swift.Error> {
    case success([RequirementCategory])
    case failure(Error)
}

extension LoadRequirementResult: Equatable where Error: Equatable {}

protocol RequirementLoader {
    associatedtype Error: Swift.Error
    func load(completion: @escaping (LoadRequirementResult<Error>) -> Void)
}
