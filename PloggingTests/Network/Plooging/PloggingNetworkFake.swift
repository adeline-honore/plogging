//
//  NetworkFake.swift
//  PloggingTests
//
//  Created by adeline honore on 15/11/2023.
//

@testable import Plogging
import UIKit
import FirebaseFirestore

class PloggingNetworkFake: PloggingNetworkProtocol {

    private let testCase: TestCase
    private let jsonExtensionType = "json"
    private let imageExtensionType = "jpg"
    private var isFailed: Bool = false

    init(testCase: TestCase, isFailed: Bool) {
        self.testCase = testCase
        self.isFailed = isFailed
    }

    func callNetworkGetPloggingList(router: PloggingRouterProtocol, completionHandler: @escaping (Result<QuerySnapshot, Error>) -> Void) {
        guard !isFailed else {
            completionHandler(.failure(ErrorType.network))
            return
        }

        let bundle = Bundle(for: PloggingNetworkFake.self)
        guard let url = bundle.url(forResource: testCase.resource, withExtension: jsonExtensionType) else {
            completionHandler(.failure(ErrorType.network))
            return
        }
//        let snapshot: QuerySnapshot = QuerySnapshot!

//        completionHandler(.success(snapshot))
    }

    func callNetworkCreateOrUpdatePlogging(plogging: Plogging, router: PloggingRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        guard !isFailed else {
            completionHandler(.failure(ErrorType.network))
            return
        }
        return completionHandler(.success(FirebaseResult.success))
    }
}
