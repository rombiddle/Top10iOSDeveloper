//
//  SharedTestHelpers.swift
//  Top10iOSDevTests
//
//  Created by Romain Brunie on 05/02/2021.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}
