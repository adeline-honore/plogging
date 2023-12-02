//
//  PloggingService.swift
//  Plogging
//
//  Created by adeline honore on 02/12/2023.
//

import Foundation
import FirebaseFirestore

protocol PloggingServiceProtocol {
    func getPloggingList(completionHandler: @escaping (Result<[Plogging], Error>) -> Void)
    func createOrUpdatePlogging(plogging: Plogging, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
}

class GetPloggingService: PloggingServiceProtocol {
    private var network: PloggingNetworkProtocol

    init(network: PloggingNetworkProtocol) {
        self.network = network
    }

    func getPloggingList(completionHandler: @escaping (Result<[Plogging], Error>) -> Void) {
        return network.callNetworkGetPloggingList(router: PloggingRouter.getPloggings) { result in
            switch result {
            case .success(let data):
                let ploggingList = self.convertAPIDocumentToPlogging(snapshot: data)
                completionHandler(.success(ploggingList))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func createOrUpdatePlogging(plogging: Plogging, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
        return network.callNetworkCreateOrUpdatePlogging(plogging: plogging, router: PloggingRouter.createOrUpdatePlogging) { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    private func convertAPIDocumentToPlogging(snapshot: (QuerySnapshot)) -> [Plogging] {
        var ploggingList: [Plogging] = []

        for ploggingDocumentList in snapshot.documents {
            let ploggingDocument = ploggingDocumentList.data()
            var ploggingToDisplay: Plogging = Plogging()

            for pair in ploggingDocument {
                switch pair.key {
                case "id":
                    ploggingToDisplay.id = pair.value as? String ?? ""
                case "admin":
                    ploggingToDisplay.admin = pair.value as? String ?? ""
                case "beginning":
                    ploggingToDisplay.beginning = pair.value as? Int ?? 1
                case "distance":
                    ploggingToDisplay.distance = pair.value as? Int ?? 2
                case "latitude":
                    ploggingToDisplay.latitude = pair.value as? Double ?? 0
                case "longitude":
                    ploggingToDisplay.longitude = pair.value as? Double ?? 0
                case "place":
                    ploggingToDisplay.place = pair.value as? String ?? ""
                case "ploggers":
                    ploggingToDisplay.ploggers = pair.value as? [String] ?? [""]
                default:
                    break
                }
            }
            ploggingList.append(ploggingToDisplay)
        }
        return ploggingList
    }
}
