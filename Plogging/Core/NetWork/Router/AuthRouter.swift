//
//  AuthRouter.swift
//  Plogging
//
//  Created by adeline honore on 02/12/2023.
//

import Foundation
import FirebaseAuth

protocol AuthRouterProtocol {
    func authentificationReference() -> Auth
}

enum AuthRouter: AuthRouterProtocol {
    var authentification: Auth { Auth.auth() }
    case createUser
    case connectUser
    case setPassword
    case forgotPassword
    case disconnectUser

    func authentificationReference() -> Auth {
        switch self {
        case .createUser, .connectUser, .setPassword, .forgotPassword, .disconnectUser:
            return authentification
        }
    }
}
