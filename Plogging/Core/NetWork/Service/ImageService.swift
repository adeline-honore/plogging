//
//  ImageService.swift
//  Plogging
//
//  Created by adeline honore on 02/12/2023.
//

import UIKit

protocol ImageServiceProtocol {
    func getImage(ploggingId: String, completionHandler: @escaping (Result<UIImage, Error>) -> Void)
    func uploadPhoto(mainImageBinary: Data, ploggingId: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void)
}

class ImageService: ImageServiceProtocol {
    private var network: ImageNetworkProtocol

    init(network: ImageNetworkProtocol) {
        self.network = network
    }

    func getImage(ploggingId: String, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
        return network.callNetworkGetImage(ploggingId: ploggingId, router: ImageRouter.getImage) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completionHandler(.success(image))
                } else {
                    completionHandler(.failure(ErrorType.network))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func uploadPhoto(mainImageBinary: Data, ploggingId: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        return network.callNetworkUploadPhoto(mainImageBinary: mainImageBinary, ploggingId: ploggingId, router: ImageRouter.uploadImage) { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(ErrorType.network))
            }
        }
    }
}
