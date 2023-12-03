//
//  TestCase.swift
//  PloggingTests
//
//  Created by adeline honore on 15/11/2023.
//

import Foundation

enum TestCase {
    case auth
    case plogging
    case image
    case uiViewController
    case uiView

    var resource: String {
        switch self {
        case .auth:
            return "auth"
        case .plogging:
            return "plogging"
        case .image:
            return "image"
        case .uiViewController:
            return "uiViewController"
        case .uiView:
            return "uiViewController"
        }
    }
}
