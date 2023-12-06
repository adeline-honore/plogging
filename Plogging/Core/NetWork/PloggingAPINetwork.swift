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
    func callNetworkGetPloggingList(router: PloggingRouterProtocol, completionHandler: @escaping (Result<[Plogging], Error>) -> Void)
    func callNetworkCreateOrUpdatePlogging(plogging: Plogging, router: PloggingRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
}

class PloggingNetwork: PloggingNetworkProtocol {
    func callNetworkGetPloggingList(router: PloggingRouterProtocol, completionHandler: @escaping (Result<[Plogging], Error>) -> Void) {
        let collectionReference = router.collectionReference()

        collectionReference.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                completionHandler(.failure(error ?? ErrorType.network))
                return
            }
            let ploggingList = self.convertAPIDocumentToPlogging(snapshot: snapshot)
            completionHandler(.success(ploggingList))
        }
    }

    func callNetworkCreateOrUpdatePlogging(plogging: Plogging, router: PloggingRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        let collectionReference = router.collectionReference()
        let ploggingDoc = convertPloggingToDocument(plogging: plogging)

        collectionReference.document(plogging.id).setData(ploggingDoc) { error in
            if error != nil {
                completionHandler(.failure(error ?? ErrorType.network))
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

    private func convertAPIDocumentToPlogging(snapshot: (QuerySnapshot)) -> [Plogging] {
        var ploggingList: [Plogging] = []

        for ploggingDocumentList in snapshot.documents {
            let ploggingDocument = ploggingDocumentList.data()
            var ploggingToDisplay: Plogging = Plogging()

            for pair in ploggingDocument {
                switch pair.key {
                case "id":
                    ploggingToDisplay.id = pair.value as? String ?? ""
                case "admin":
                    ploggingToDisplay.admin = pair.value as? String ?? ""
                case "beginning":
                    ploggingToDisplay.beginning = pair.value as? Int ?? 1
                case "distance":
                    ploggingToDisplay.distance = pair.value as? Int ?? 2
                case "latitude":
                    ploggingToDisplay.latitude = pair.value as? Double ?? 0
                case "longitude":
                    ploggingToDisplay.longitude = pair.value as? Double ?? 0
                case "place":
                    ploggingToDisplay.place = pair.value as? String ?? ""
                case "ploggers":
                    ploggingToDisplay.ploggers = pair.value as? [String] ?? [""]
                default:
                    break
                }
            }
            ploggingList.append(ploggingToDisplay)
        }
        return ploggingList
    }
}
