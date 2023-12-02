//
//  PloggingRouter.swift
//  Plogging
//
//  Created by adeline honore on 02/12/2023.
//

import Foundation
import FirebaseFirestore

protocol PloggingRouterProtocol {
    func collectionReference() -> CollectionReference
}

enum PloggingRouter: PloggingRouterProtocol {
    var firestoreDataBase: Firestore {Firestore.firestore()}
    case getPloggings
    case createOrUpdatePlogging

    func collectionReference() -> CollectionReference {
        switch self {
        case .getPloggings, .createOrUpdatePlogging:
            return firestoreDataBase.collection("ploggingList")
        }
    }
}
