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
    
    case fromPersonalToDetails
    
    case fromCreateToLocalSearch
    
    case fromDetailsToCollectionView
    
    case fromCollectionViewToImage
        
    var identifier: String {
        switch self {
        case .appOverviewPage:
            return "appOverviewPage"
        case .fromMapToPlogging:
            return "fromMapToPlogging"
        case .fromMapToCreatePlogging:
            return "fromMapToCreatePlogging"
            
        case .fromPersonalToDetails:
            return "fromPersonalToDetails"
            
        case .fromCreateToLocalSearch:
            return "fromCreateToLocalSearch"
            
        case .fromDetailsToCollectionView:
            return "fromDetailsToCollectionView"
            
        case .fromCollectionViewToImage:
            return "fromCollectionViewToImage"
        }
    }
}
