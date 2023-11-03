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
    
    func createDatabasePlogging(ploggingArray: [Plogging], completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {

        var array = [Any]()

        ploggingArray.forEach { plogging in
            var item = [
                "id": plogging.id as NSString,
                "admin": plogging.admin as NSString,
                "beginning": plogging.beginning as NSString,
                "place": plogging.place as NSString,
                "latitude": plogging.latitude as NSNumber,
                "longitude": plogging.longitude as NSNumber,
                "ploggers": plogging.ploggers as NSArray,
                "distance": plogging.distance as NSNumber
            ]
            array.append(item)
        }

        DatabaseURL.ref.child("datas").setValue(array) {
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                completionHandler(.failure(ErrorType.network))
            } else {
                completionHandler(.success(FirebaseResult.success))
            }
        }
    }

    func getPloggingList(completionHandler: @escaping (Result<[Plogging], ErrorType>) -> Void) {
        DatabaseURL.ref.observe(DataEventType.childAdded) { snapshot   in
            var ploggingArray = [Plogging]()
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                let dict = rest.value as? NSDictionary

                var newPlogging = Plogging()
                newPlogging.admin = dict?.value(forKey: "admin") as! String
                newPlogging.beginning = dict?.value(forKey: "beginning") as! String
                newPlogging.distance = dict?.value(forKey: "distance") as! Int
                newPlogging.id = dict?.value(forKey: "id") as! String
                newPlogging.latitude = dict?.value(forKey: "latitude") as! Double
                newPlogging.longitude = dict?.value(forKey: "longitude") as! Double
                newPlogging.place = dict?.value(forKey: "place") as! String
                newPlogging.ploggers = dict?.value(forKey: "ploggers") as! [String]

                ploggingArray.append(newPlogging)
            }

            if snapshot.exists() {
                completionHandler(.success(ploggingArray))
            } else {
                completionHandler(.failure(ErrorType.snapshotDoNotExist))
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
