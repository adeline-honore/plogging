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
    func getAPIPloggingList(completionHandler: @escaping (Result<[Plogging], Error>) -> ())
}

class NetworkService: PloggingServiceProtocol {

    private var network: NetworkProtocol

    init(network: NetworkProtocol) {
        self.network = network
    }
    
    func getAPIPloggingList(completionHandler: @escaping (Result<[Plogging], Error>) -> ()) {
        var ploggingList: [Plogging] = []

        let db = Firestore.firestore()
        db.collection("ploggingList").getDocuments { snapshot, error in

            if error == nil && snapshot != nil {
                for plog in snapshot!.documents {
                    let one = plog.data()
                    print(one)
                    var ploggg: Plogging = Plogging()

                    for hggj in one {
                        if hggj.key == "id" {
                            ploggg.id = hggj.value as! String
                        }
                        if hggj.key == "admin" {
                            ploggg.admin = hggj.value as! String
                        }
                        if hggj.key == "beginning" {
                            ploggg.beginning = hggj.value as! Int
                        }
                        if hggj.key == "distance" {
                            ploggg.distance = hggj.value as! Int
                        }
                        if hggj.key == "latitude" {
                            ploggg.latitude = hggj.value as! Double
                        }
                        if hggj.key == "longitude" {
                            ploggg.longitude = hggj.value as! Double
                        }
                        if hggj.key == "place" {
                            ploggg.place = hggj.value as! String
                        }
                        if hggj.key == "ploggers" {
                            ploggg.ploggers = hggj.value as! [String]
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

        let db = Firestore.firestore()
        db.collection("ploggingList").document(plogging.id).setData(ploggingDoc) { error in
            
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
            let db = Firestore.firestore()
            db.collection("images").document().setData(["url" : path])

            if error == nil && metadata != nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    func getImageList(completionHandler: @escaping (Result<[PloggingImage], ErrorType>) -> Void) {

        var ploggingImageList: [PloggingImage] = []
        var photoList = [UIImage]()

        let db = Firestore.firestore()
        db.collection("images").getDocuments { snapshot, error in

            if error == nil && snapshot != nil {
                var pathList = [String]()

                for doc in snapshot!.documents {
                    pathList.append(doc["url"] as! String)
                }

                for onePath in pathList {
                    let storageRef = Storage.storage().reference()
                    let fileRef = storageRef.child(onePath)
                    fileRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                        if error == nil && data != nil {
                            if let imagge = UIImage(data: data!) {
                                photoList.append(imagge)

                                let ploggingImage = PloggingImage(id: onePath, mainImage: imagge)
                                ploggingImageList.append(ploggingImage)
                            }
                            completionHandler(.success(ploggingImageList))
                        } else {
                            completionHandler(.failure(ErrorType.network))
                        }
                    }
                }
            }
        }
    }
}
