//
//  PloggingService.swift
//  Plogging
//
//  Created by HONORE Adeline on 21/10/2022.
//

import Foundation

class PloggingService {
    
    typealias PloggingServiceResult = Result<[Plogging], PloggingServiceError>
    
    enum PloggingServiceError: Error {
        case fileNotFound
        case unableToDecode
    }
    
    func load(completion: (PloggingServiceResult) -> Void) {
        guard
            let fileName = Bundle.main.url(forResource: "SomeDataz", withExtension: "json"),
            let ploggingData = try? Data(contentsOf: fileName)
        else {
            completion(.failure(.fileNotFound))
            return
        }
        
        do {
            let ploggingResult = try transformToPloggingsModel(data: ploggingData)
            completion(.success(ploggingResult.datas))
        } catch {
            completion(.failure(.unableToDecode))
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
