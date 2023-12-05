//
//  NetworkFake.swift
//  PloggingTests
//
//  Created by adeline honore on 15/11/2023.
//

@testable import Plogging
import Foundation

class PloggingNetworkFake: PloggingNetworkProtocol {

    private let testCase: TestCase
    private let jsonExtensionType = "json"
    private let imageExtensionType = "jpg"
    private var isFailed: Bool = false

    init(testCase: TestCase, isFailed: Bool) {
        self.testCase = testCase
        self.isFailed = isFailed
    }

    func callNetworkGetPloggingList(router: PloggingRouterProtocol, completionHandler: @escaping (Result<[Plogging], Error>) -> Void) {
        guard !isFailed else {
            completionHandler(.failure(ErrorType.network))
            return
        }

        let data = prepareData()

        let list = try? transformPloggings(data: data)

        completionHandler(.success(list ?? [Plogging()]))
    }

    func callNetworkCreateOrUpdatePlogging(plogging: Plogging, router: PloggingRouterProtocol, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        guard !isFailed else {
            completionHandler(.failure(ErrorType.network))
            return
        }
        return completionHandler(.success(FirebaseResult.success))
    }

    private func prepareData() -> Data {
        let bundle = Bundle.main
        let url = bundle.url(forResource: testCase.resource, withExtension: jsonExtensionType)!
        guard let data = try? Data(contentsOf: url) else { return Data() }
        return data
    }

    private func transformPloggings(data: Data) throws -> [Plogging] {
        return try JSONDecoder().decode([Plogging].self, from: data)
    }
}
