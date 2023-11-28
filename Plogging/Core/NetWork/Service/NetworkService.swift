//
//  NetworkService.swift
//  Plogging
//
//  Created by HONORE Adeline on 28/10/2023.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

protocol PloggingServiceProtocol {
    func createOrUpdateAPIPlogging(plogging: Plogging, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
    func getAPIPloggingList(completionHandler: @escaping (Result<[Plogging], Error>) -> Void)
}

class NetworkService: PloggingServiceProtocol {

    private var network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }

    func getAPIPloggingList(completionHandler: @escaping (Result<[Plogging], Error>) -> Void) {
        var ploggingList: [Plogging] = []

        let firestoreDataBase = Firestore.firestore()
        firestoreDataBase.collection("ploggingList").getDocuments { snapshot, error in

            if error == nil && snapshot != nil {
                for ploggingDocumentList in snapshot!.documents {
                    let ploggingDocument = ploggingDocumentList.data()
                    var ploggg: Plogging = Plogging()

                    for pair in ploggingDocument {
                        if pair.key == "id" {
                            ploggg.id = pair.value as? String ?? ""
                        }
                        if pair.key == "admin" {
                            ploggg.admin = pair.value as? String ?? ""
                        }
                        if pair.key == "beginning" {
                            ploggg.beginning = pair.value as? Int ?? 1
                        }
                        if pair.key == "distance" {
                            ploggg.distance = pair.value as? Int ?? 2
                        }
                        if pair.key == "latitude" {
                            ploggg.latitude = pair.value as? Double ?? 0
                        }
                        if pair.key == "longitude" {
                            ploggg.longitude = pair.value as? Double ?? 0
                        }
                        if pair.key == "place" {
                            ploggg.place = pair.value as? String ?? ""
                        }
                        if pair.key == "ploggers" {
                            ploggg.ploggers = pair.value as? [String] ?? [""]
                        }
                    }
                    ploggingList.append(ploggg)
                }
                    completionHandler(.success(ploggingList))
                } else {
                    completionHandler(.failure(ErrorType.network))
            }
        }
    }

    func createOrUpdateAPIPlogging(plogging: Plogging, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {

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

        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("ploggingList").document(plogging.id).setData(ploggingDoc) { error in
            if error == nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    func uploadPhoto(mainImageBinary: Data, ploggingId: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {

        let path = "images/\(ploggingId).jpg"
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(path)

        fileRef.putData(mainImageBinary, metadata: nil) { metadata, error in
            let firestoreDatabase = Firestore.firestore()
            firestoreDatabase.collection("images").document().setData(["url": path])

            if error == nil && metadata != nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    func getPloggingImage(ploggingId: String, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {

        let path = "images/\(ploggingId).jpg"
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(path)

        fileRef.getData(maxSize: 5 * 1024 * 1024) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completionHandler(.success(image))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
