//
//  TestCase.swift
//  PloggingTests
//
//  Created by adeline honore on 15/11/2023.
//

import Foundation

enum TestCase {
    case auth
    case ploggingList

    var resource: String {
        switch self {
        case .auth:
            return "auth"
        case .ploggingList:
            return "ploggingList"
        }
    }
}
