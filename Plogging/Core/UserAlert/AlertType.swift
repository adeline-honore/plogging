//
//  AlertType.swift
//  Plogging
//
//  Created by HONORE Adeline on 09/10/2022.
//

import Foundation

enum AlertType{
    
    case locationSaved
    
    
    
    var message: String {
        switch self {
        case .locationSaved:
            return "This location is saved ."
        }
    }
    
}

