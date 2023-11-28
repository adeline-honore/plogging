//
//  NetworkFake.swift
//  PloggingTests
//
//  Created by adeline honore on 15/11/2023.
//

import Foundation
@testable import Plogging
import UIKit

class NetworkFake: NetworkProtocol {

    private let testCase: TestCase
    private var isFailed: Bool = false

    init(testCase: TestCase, isFailed: Bool) {
        self.testCase = testCase
        self.isFailed = isFailed
    }

    func callNetwork(router: RouterProtocol, completionHandler: @escaping (Result<Data,Error>) -> ()) {
        
        guard !isFailed else {
            completionHandler(.failure(ErrorType.network))
            return
        }

        switch testCase {
        case .auth:
            return completionHandler(.success(prepareAuthData()))
        case .ploggingList:
            return completionHandler(.success(preparePloggingListData()))
        }
    }

    private func prepareAuthData() -> Data {
        let bundle = Bundle(for: NetworkFake.self)
        let url = bundle.url(forResource: testCase.resource, withExtension: "json")!
        guard let authData = try Data(contentsOf: url) else {
            return Data()
        }
        return authData
    }

    private func preparePloggingListData() -> Data {
        let bundle = Bundle(for: NetworkFake.self)
        let url = bundle.url(forResource: testCase.resource, withExtension: "json")!
        guard let ploggingListData = try Data(contentsOf: url) else {
            return Data()
        }
        return ploggingListData
    }
}
