//
//  ImageAPINetwork.swift
//  Plogging
//
//  Created by adeline honore on 02/12/2023.
//

import Foundation

protocol ImageNetworkProtocol {
    func callNetworkGetImage(ploggingId: String, router: GetImageRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void)
}

class ImageNetwork: ImageNetworkProtocol {
    func callNetworkGetImage(ploggingId: String, router: GetImageRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let storageReference = router.getStorageReference()
        let path = "images/\(ploggingId).jpg"

        let fileReference = storageReference.child(path)

        storageReference.getData(maxSize: 5 * 1024 * 1024) { result, error in
            guard let result = result, error == nil else {
                completionHandler(.failure(error!))
                return
            }
            completionHandler(.success(result))
        }
    }
}
