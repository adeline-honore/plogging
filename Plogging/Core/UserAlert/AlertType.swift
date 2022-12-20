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
    case ploggingWithoutPlace
    
    case network
    
    case noPersonalPlogging
    
    case isTakingPart
    case isNotTakingPart
    
    case mailAppUnavailable
    
    var message: String {
        switch self {
        case .locationSaved:
            return "This location is saved ."
        case .locationNotSaved:
            return "Oups ! This location is not saved ."
        case .ploggingSaved:
            return "Your plogging race is saved ."
        case .ploggingNotSaved:
            return "Oups ! Your plogging race is not saved . Please try again ."
        case .ploggingWithoutPlace:
            return "Please enter a departure address ."
            
        case .network:
            return "Oups ! Network troubles ."
            
        case .noPersonalPlogging:
            return "No personal plogging ."
            
        case .isTakingPart:
            return "Yeah ! You will participate at this plogging ."
        case .isNotTakingPart:
            return "Ok ! You will not take part at this plogging ."
            
        case .mailAppUnavailable:
            return "Mail app unavailable . Please try for yourself ."
        }
    }
    
}

