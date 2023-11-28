//
//  Network.swift
//  Plogging
//
//  Created by adeline honore on 15/11/2023.
//

import Foundation
import FirebaseDatabase
import Firebase

protocol RouterProtocol {
    var baseURL: String { get }
    func buildRequest()
}

protocol NetworkProtocol {
    func callNetwork(router: RouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void)
}

class Network: NetworkProtocol {
    func callNetwork(router: RouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let urlRequest = router.baseURL
    }
}

enum PloggingRouter: RouterProtocol {

    var baseURL: String {
        "https://plogging-412ed-default-rtdb.europe-west1.firebasedatabase.app/"
    }

    var ref: DatabaseReference {
        Database.database(url: "https://plogging-412ed-default-rtdb.europe-west1.firebasedatabase.app/").reference(fromURL: "https://plogging-412ed-default-rtdb.europe-west1.firebasedatabase.app/")
    }

    case createApiPlogging(Any)
    case getApiPloggingList
    case setApiPloggingList

    func buildRequest() {
        switch self {
        case .createApiPlogging:
            ref.child("datas").setValue(Any.self)
        case .getApiPloggingList:
            print("getApiPloggingList")
        case .setApiPloggingList:
             ref.updateChildValues([AnyHashable: Any]())
        }
    }
}

enum AuthRouter: RouterProtocol {
    var baseURL: String {
        ""
    }

    case createApiUser
    case connectUser
    case forgotPasswordRequestApi
    case disconnectUser

    func buildRequest() {
        switch self {
        case .createApiUser:
            print("createApiUser")
        case .connectUser:
            print("connectUser")
        case .forgotPasswordRequestApi:
            print("forgotPasswordRequestApi")
        case .disconnectUser:
            print("disconnectUser")
        }
    }

}
