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
    
    private let mapService = MapService()
    
    func load(completionHandler: @escaping (Result<[Plogging], Error>) -> ()) {
    
        mapService.getPloggingList() { result in
            switch result {
            case .success(let data):
                print(data)
                do {
                    let firebaseData = try self.transformToPloggingsModel(data: data)
                    let ploggingList = firebaseData.datas.map {$0}

                    completionHandler(.success(ploggingList))
                } catch {
                    print("eeee")
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                print(error)
                completionHandler(.failure(error))
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
}
