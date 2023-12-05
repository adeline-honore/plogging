//
//  TestCase.swift
//  PloggingTests
//
//  Created by adeline honore on 05/12/2023.
//

import Foundation

enum TestCase {
    case plogging
    case auth
    case image
    case uiViewController
    case uiView

    var resource: String {
        switch self {
        case .plogging:
            return "plogging"
        case .auth:
            return "authentification"
        case .image:
            return "image"
        case .uiViewController:
            return "uiViewController"
        case .uiView:
            return "uiView"
        }
    }
}
