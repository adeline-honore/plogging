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
