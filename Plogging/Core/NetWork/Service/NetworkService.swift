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
    
    func createDatabasePlogging(ploggingUI: PloggingUI, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        
        // create object with accepted datas
        let ploggingToSave:[String: Any] = [
            "id": NSString(string: ploggingUI.id),
            "admin": NSString(string: ploggingUI.admin),
            "beginning": NSNumber(value: ploggingUI.beginning.timeIntervalSince1970),
            "place": NSString(string: ploggingUI.place),
            "latitude": NSNumber(value: ploggingUI.latitude ?? 0.0),
            "longitude": NSNumber(value: ploggingUI.longitude ?? 0.0),
            "ploggers": NSArray(array: [ploggingUI.admin]),
            "distance": NSNumber(value: ploggingUI.distance)
            ]
        
        DatabaseURL.ref.child("plogging\(ploggingUI.id)").setValue(ploggingToSave) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                completionHandler(.failure(ErrorType.network))
            } else {
                completionHandler(.success(FirebaseResult.success))
            }
        }
    }

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
