//
//  Network.swift
//  Plogging
//
//  Created by adeline honore on 15/11/2023.
//

import Foundation
import FirebaseDatabase
import Firebase
import FirebaseFirestore
import FirebaseStorage

protocol PloggingNetworkProtocol {
    func callNetworkGetPloggingList(router: PloggingRouterProtocol, completionHandler: @escaping (Result<QuerySnapshot, Error>) -> Void)
    func callNetworkCreateOrUpdatePlogging(plogging: Plogging, router: PloggingRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
}

class PloggingNetwork: PloggingNetworkProtocol {
    func callNetworkGetPloggingList(router: PloggingRouterProtocol, completionHandler: @escaping (Result<QuerySnapshot, Error>) -> Void) {
        let collectionReference = router.collectionReference()

        collectionReference.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                completionHandler(.failure(error!))
                return
            }
            completionHandler(.success(snapshot))
        }
    }

    func callNetworkCreateOrUpdatePlogging(plogging: Plogging, router: PloggingRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        let collectionReference = router.collectionReference()
        let ploggingDoc = convertPloggingToDocument(plogging: plogging)

        collectionReference.document(plogging.id).setData(ploggingDoc) { error in
            if error != nil {
                completionHandler(.failure(error!))
                return
            } else {
                completionHandler(.success(FirebaseResult.success))
            }
        }
    }

    private func convertPloggingToDocument(plogging: Plogging) -> [String: Any] {
        let ploggingDoc: [String: Any] = [
            "admin": plogging.admin,
            "beginning": plogging.beginning,
            "distance": plogging.distance,
            "id": plogging.id,
            "latitude": plogging.latitude,
            "longitude": plogging.longitude,
            "place": plogging.place,
            "ploggers": plogging.ploggers
        ]
        return ploggingDoc
    }
}

//protocol CreateOrUpdatePloggingNetworkProtocol {
//    func callNetwork(router: PloggingRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void)
//}
//
//class CreateOrUpdatePloggingNetwork: CreateOrUpdatePloggingNetworkProtocol {
//
//    func callNetwork(router: PloggingRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void) {
//        let collectionReference = router.collectionReference()
//
//        collectionReference.document(plogging.id).setData(ploggingDoc) { data, error in
//            guard let data = data, error == nil else {
//                completionHandler(.failure(error!))
//                return
//            }
////            completionHandler(.success(data))
//        }
//    }
//}










//struct StorageURL {
//    let url: String = "https://plogging-412ed-default-rtdb.europe-west1.firebasedatabase.app/"
//
//    static var ref: DatabaseReference! = Database.database(url: "https://plogging-412ed-default-rtdb.europe-west1.firebasedatabase.app/").reference(fromURL: "https://plogging-412ed-default-rtdb.europe-west1.firebasedatabase.app/")
//}













//protocol CreateOrUpdatePloggingNetworkProtocol {
//    func callNetwork(router: PloggingRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> ())
//}





















//class GetPloggingAPINetwork: GetPloggingNetworkProtocol {
//    func callNetwork(router: PloggingRouterProtocol, completionHandler: @escaping (Result<QuerySnapshot, Error>) -> ()) { responseData in
//            switch responseData {
//            case .success(let data):
//                completionHandler(.success(data))
//            case .failure(let error):
//                completionHandler(.failure(error))
//            }
//        }
//        //        let urlRequest = router.buildRequest()
//    }
//}


//
//protocol CreateOrUpdatePloggingNetworkProtocol {
//    func callNetwork(router: PloggingRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> ())
//}

//class CreateOrUpdatePloggingAPINetwork: CreateOrUpdatePloggingNetworkProtocol {
//    func callNetwork(router: PloggingAPIRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void) {
//
//        router.request { responseData in
//            switch responseData {
//            case .success(let data):
//                completionHandler(.success(data))
//            case .failure(let error):
//                completionHandler(.failure(error))
//            }
//        }
//        //        let urlRequest = router.buildRequest()
//    }
//}



protocol PloggingAPIRouterProtocol {
    var firestoreDataBase: Firestore { get }
    func buildRequest() -> CollectionReference
    func request(completionHandler: @escaping (Result<Data, Error>) -> Void)
}

protocol PloggingAPINetworkProtocol {
    func callNetwork(router: PloggingAPIRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void)
}

class PloggingAPINetwork: PloggingAPINetworkProtocol {
    func callNetwork(router: PloggingAPIRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void) {

        router.request { responseData in
            switch responseData {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        //        let urlRequest = router.buildRequest()
    }
}

//enum PloggingRouter: PloggingAPIRouterProtocol {
//    var firestoreDataBase: Firestore {Firestore.firestore()}
//
//    var ref: DatabaseReference {
//        Database.database(url: "https://plogging-412ed-default-rtdb.europe-west1.firebasedatabase.app/").reference(fromURL: "https://plogging-412ed-default-rtdb.europe-west1.firebasedatabase.app/")
//    }
//
//    static var ploggingToAdd: Plogging { Plogging()}
//
//    case createApiPlogging
//    case getApiPloggingList
//
//    func buildRequest() -> CollectionReference {
//        switch self {
//        case .createApiPlogging, .getApiPloggingList:
//            print("$$  getApiPloggingList / createApiPlogging")
//            return firestoreDataBase.collection("ploggingList")
//        }
//    }
//
//    func request(completionHandler: @escaping (Result<Data, Error>) -> Void) {
//        switch self {
//        case .createApiPlogging:
//            print("zzzz")
//            buildRequest().document(PloggingRouter.ploggingToAdd.id).setData(convertPloggingToDocument(plogging: PloggingRouter.ploggingToAdd))
//        case .getApiPloggingList:
//            print("getApiPloggingList")
//            let ghfj: (QuerySnapshot?, (Error)?) -> Void = nil
//            buildRequest().getDocuments(completion: ghfj)
//        }
//    }
    
//    func requestReturnData(completionHandler: @escaping (Result<Data, Error>) -> Void) {
//        case .createApiPlogging:
//            buildRequest().document(PloggingRouter.ploggingToAdd.id).setData(convertPloggingToDocument(plogging: PloggingRouter.ploggingToAdd))
//    }

//    func requestReturnSnapshot(completionHandler: @escaping (QuerySnapshot?, (any Error)?/*Result<Data, Error>*/) -> Void) {
//        switch self {
//        case .createApiPlogging:
//            buildRequest().document(PloggingRouter.ploggingToAdd.id).setData(convertPloggingToDocument(plogging: PloggingRouter.ploggingToAdd))
//        case .getApiPloggingList:
//            print("getApiPloggingList")
//            buildRequest().getDocuments(completion: completionHandler)
//            buildRequest().getDocuments {_, _ in }
//            buildRequest().document().
//        }
//    }

    
//}

protocol AuthAPIRouterProtocol {
    var authAPIRequest: Auth { get }
    func request(completionHandler: @escaping (Result<Data, Error>) -> Void)
}

//enum AuthRouter: AuthAPIRouterProtocol {
//    static var email: String { "" }
//    static var password: String { "" }
//    var authAPIRequest: Auth {Auth.auth()}
//
//    case createApiUser
//    case connectUser
//    case forgotPasswordRequestApi
//    case disconnectUser
//
//    func request(completionHandler: @escaping (Result<Data, Error>) -> Void) {
//        switch self {
//        case .createApiUser:
//            print("createApiUser")
//        case .connectUser:
//            print("connectUser")
//            authAPIRequest.signIn(withEmail: AuthRouter.email, password: AuthRouter.password)
//        case .forgotPasswordRequestApi:
//            print("forgotPasswordRequestApi")
//        case .disconnectUser:
//            print("disconnectUser")
//            authAPIRequest.signOut()
//        }
//    }
//}

protocol AuthAPINetworkProtocol {
    func callNetwork(router: AuthAPIRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void)
}

class AuthAPINetwork: AuthAPINetworkProtocol {
    func callNetwork(router: AuthAPIRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void) {

        router.request { responseData in
            switch responseData {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        //        let urlRequest = router.buildRequest()
    }
}
