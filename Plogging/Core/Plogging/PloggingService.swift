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
                completionHandler(.failure(.network))
            }
        }
    }
    
//    func savePloggingRequest(ploggingUI: PloggingUI, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {
//        
//        networkService.createDatabasePlogging(ploggingUI: ploggingUI) { result in
//            switch result {
//            case .success:
//                completionHandler(.success(FirebaseResult.success))
//            case .failure:
//                completionHandler(.failure(.network))
//            }
//        }
//    }

    func load(completionHandler: @escaping (Result<[Plogging], ErrorType>) -> Void) {

        networkService.getPloggingList { result in
            switch result {
            case .success(let data):
                if !data.isEmpty {
                    do {
                        let firebaseData = try self.transformToPloggingsModel(data: data)
                        //                    let ploggingList = firebaseData.datas.map {$0}
                        
                        //                    completionHandler(.success(ploggingList))
//
                        let ploggingArray = firebaseData.datas.map{$0}
                        completionHandler(.success(ploggingArray))
                    } catch {
                        print("eeee")
                        completionHandler(.failure(ErrorType.network))
                    }} else {completionHandler(.success([]))}
            case .failure(let error):
                print(error)
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

    private func transformToPloggingsModel(data: Data) throws -> PloggingDatas {

        do {
            return try JSONDecoder().decode(PloggingDatas.self, from: data)
        } catch {
            throw error
        }
    }
    
//    private func transformToPloggingsModel(data: Data) throws -> PloggingDatas {
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
