//
//  AlertType.swift
//  Plogging
//
//  Created by HONORE Adeline on 09/10/2022.
//

import Foundation

enum AlertType{
    
    case locationSaved
    case ploggingSaved
    
    
    
    var message: String {
        switch self {
        case .locationSaved:
            return "This location is saved ."
        case .ploggingSaved:
            return "Your plogging race is saved ."
        }
    }
    
}

