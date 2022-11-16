//
//  AlertType.swift
//  Plogging
//
//  Created by HONORE Adeline on 09/10/2022.
//

import Foundation

enum AlertType{
    
    case locationSaved
    case locationNotSaved
    
    case ploggingSaved
    case ploggingNotSaved
    
    case network
    
    case noPersonalPlogging
    
    
    var message: String {
        switch self {
        case .locationSaved:
            return "This location is saved ."
        case .locationNotSaved:
            return "Oups ! This location is not saved ."
        case .ploggingSaved:
            return "Your plogging race is saved ."
        case .ploggingNotSaved:
            return "Your plogging race is not saved ."
            
        case .network:
            return "Oups ! Network troubles ."
            
        case .noPersonalPlogging:
            return "No personal plogging ."
        }
    }
    
}

