//
//  SegueIdentifier.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/10/2022.
//

import Foundation

enum SegueIdentifier {
    
    case fromFirstToMap
    
    case fromMapToPlogging
    case fromMapToCreatePlogging
    
    var identifier: String {
        switch self {
        case .fromFirstToMap:
            return "fromFirstToMap"
        case .fromMapToPlogging:
            return "fromMapToPlogging"
        case .fromMapToCreatePlogging:
            return "fromMapToCreatePlogging"
        }
    }
}
