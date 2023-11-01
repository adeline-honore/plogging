//
//  NetworkService.swift
//  Plogging
//
//  Created by HONORE Adeline on 28/10/2023.
//

import Foundation
import FirebaseDatabase
//import FirebaseStorage

class NetworkService {

    func getPloggingList(completionHandler: @escaping (Result<Data, Error>) -> Void) {

        DatabaseURL.ref.observe(DataEventType.childAdded) { snapshot  in

            guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any) else { return }

            if !data.isEmpty {
                completionHandler(.success(data))
            } else {
                print("eeee")
            }
        }
    }

    func setDatabasePlogging(ploggingUI: PloggingUI, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        guard let key = DatabaseURL.ref.child("datas").childByAutoId().key else { return }

        let ploggingSetted = [
            "beginning": ploggingUI.beginning,
            "place": ploggingUI.place,
            "latitude": ploggingUI.latitude ?? 0,
            "longitude": ploggingUI.longitude ?? 0,
            "ploggers": ploggingUI.ploggers ?? [ploggingUI.admin],
            "distance": ploggingUI.distance
        ] as [String: Any]

        let childUpdates = ["/datas/\(key)": ploggingSetted,
                            "/user-posts/\(ploggingUI.id)/\(key)/": ploggingSetted]
        DatabaseURL.ref.updateChildValues(childUpdates)

    }

    func uploadPhoto(ploggingUI: PloggingUI, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {

//        let storageRef = Storage.storage().reference()
//
//        guard let imageData = ploggingUI.mainImage?.jpegData(compressionQuality: 0.8) else { return }
//
//        let fileRef = storageRef.child("images/\(ploggingUI.id).jpg")
//
//        let uploadTask = fileRef.putData(imageData) { metadata, error in
//
//            if error == nil && metadata != nil {
//                
//            }
//        }
    }
}
