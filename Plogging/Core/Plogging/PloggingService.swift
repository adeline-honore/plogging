//
//  PloggingService.swift
//  Plogging
//
//  Created by HONORE Adeline on 21/10/2022.
//

import Foundation

class PloggingService {

//    typealias PloggingServiceResult = Result<[Plogging], PloggingServiceError>

//    enum PloggingServiceError: Error {
//        case fileNotFound
//        case unableToDecode
//    }

    private let networkService = NetworkService()
    
    func savePloggingRequest(ploggingArray: [Plogging], completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        
        networkService.createDatabasePlogging(ploggingArray: ploggingArray) { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(.snapshotDoNotExist))
            }
        }
    }

    func load(completionHandler: @escaping (Result<[Plogging], ErrorType>) -> Void) {

        networkService.getPloggingList { result in
            
            switch result {
            case .success(let ploggingArray):
                completionHandler(.success(ploggingArray))
            case .failure(let error):
                print(error)
                completionHandler(.failure(ErrorType.network))
            }
        }
    }
    
//    private func transformToPloggingsModel(data: Data) throws -> PloggingDatas? {
//
//        do {
//            return try JSONDecoder().decode(PloggingDatas.self, from: data)
//        } catch {
//            throw error
//        }
//    }

    func setPlogging(ploggingUI: PloggingUI, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {

        networkService.setDatabasePlogging(ploggingUI: ploggingUI) { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(.network))
            }
        }
    }
    
    func savePhoto(ploggingUI: PloggingUI, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
        
        networkService.uploadPhoto(ploggingUI: ploggingUI) { result in
            switch result {
            case .success:
                completionHandler(.success(FirebaseResult.success))
            case .failure:
                completionHandler(.failure(.network))
            }
        }
    }
}
