//
//  ImageAPINetwork.swift
//  Plogging
//
//  Created by adeline honore on 02/12/2023.
//

import Foundation

protocol ImageNetworkProtocol {
    func callNetworkGetImage(ploggingId: String, router: ImageRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void)
    func callNetworkUploadPhoto(mainImageBinary: Data, ploggingId: String, router: ImageRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void)
}

class ImageNetwork: ImageNetworkProtocol {
    func callNetworkGetImage(ploggingId: String, router: ImageRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let storageReference = router.getStorageReference()
        let path = "images/\(ploggingId).jpg"

        storageReference.getData(maxSize: 5 * 1024 * 1024) { result, error in
            guard let result = result, error == nil else {
                completionHandler(.failure(error!))
                return
            }
            completionHandler(.success(result))
        }
    }

    func callNetworkUploadPhoto(mainImageBinary: Data, ploggingId: String, router: ImageRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        let storageReference = router.getStorageReference()
        let path = "images/\(ploggingId).jpg"
        let fileReference = storageReference.child(path)

        fileReference.putData(mainImageBinary, metadata: nil) { metadata, error in
                router.firestoreDatabase.collection("images").document().setData(["url": path])

             if metadata != nil && error == nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }
}
