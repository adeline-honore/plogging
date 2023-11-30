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
