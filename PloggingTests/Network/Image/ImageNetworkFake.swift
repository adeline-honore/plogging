//
//  ImageNetworkFake.swift
//  PloggingTests
//
//  Created by adeline honore on 03/12/2023.
//

import UIKit
@testable import Plogging

class ImageNetworkFake: ImageNetworkProtocol {
    private let testCase: TestCase
    private var isFailed: Bool = false

    init(testCase: TestCase, isFailed: Bool) {
        self.testCase = testCase
        self.isFailed = isFailed
    }

    func callNetworkGetImage(ploggingId: String, router: ImageRouterProtocol, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard !isFailed else { return completionHandler(.failure(ErrorType.network)) }

           return completionHandler(.success(prepareImageData()))
    }

    func callNetworkUploadPhoto(mainImageBinary: Data, ploggingId: String, router: ImageRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        guard !isFailed else {
            completionHandler(.failure(ErrorType.network))
            return
        }
        return completionHandler(.success(FirebaseResult.success))
    }

    private func prepareImageData() -> Data {
        let image = UIImage(named: "icon")
        let data = image!.jpegData(compressionQuality: 1)
        return data!
    }
}
