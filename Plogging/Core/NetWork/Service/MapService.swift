//
//  MapService.swift
//  Plogging
//
//  Created by HONORE Adeline on 28/10/2023.
//

import Foundation
import FirebaseDatabase

class MapService {
    
    func getPloggingList(completionHandler: @escaping (Result<Data, Error>) -> ()) {
        
        DatabaseURL.ref.observe(DataEventType.childAdded) { snapshot  in
            
            guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any) else { return }
            
            if !data.isEmpty {
                completionHandler(.success(data))
            } else {
                print("eeee")
            }
        }
    }
}

