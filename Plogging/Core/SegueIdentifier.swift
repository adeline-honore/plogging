//
//  SegueIdentifier.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/10/2022.
//

import Foundation

enum SegueIdentifier {
    
    case appOverviewPage
    
    case fromMapToPlogging
    case fromMapToCreatePlogging
    case fromMapToSignInOrUP
    
    case fromPersonalToDetails
    
    case fromCreateToLocalSearch
    
    case fromDetailsToCollectionView
    case fromDetailsToEmail
    
    case fromCollectionViewToImage
        
    var identifier: String {
        switch self {
        case .appOverviewPage:
            return "appOverviewPage"
        case .fromMapToPlogging:
            return "fromMapToPlogging"
        case .fromMapToCreatePlogging:
            return "fromMapToCreatePlogging"
        case .fromMapToSignInOrUP:
            return "fromMapToLogin"
            
        case .fromPersonalToDetails:
            return "fromPersonalToDetails"
            
        case .fromCreateToLocalSearch:
            return "fromCreateToLocalSearch"
            
        case .fromDetailsToCollectionView:
            return "fromDetailsToCollectionView"
        case .fromDetailsToEmail:
            return "fromDetailsToEmail"
            
        case .fromCollectionViewToImage:
            return "fromCollectionViewToImage"
        }
    }
}
