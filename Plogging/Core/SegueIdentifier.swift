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
    case fromMapToSignInOrUp

    case fromPersonalToDetails
    case fromPersonalToSignInOrUp

    case fromCreateToLocalSearch

    case fromDetailsToSignInOrUp
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
        case .fromMapToSignInOrUp:
            return "fromMapToSignInOrUp"

        case .fromPersonalToDetails:
            return "fromPersonalToDetails"
        case .fromPersonalToSignInOrUp:
            return "fromPersonalToSignInOrUp"

        case .fromCreateToLocalSearch:
            return "fromCreateToLocalSearch"

        case .fromDetailsToSignInOrUp:
            return "fromDetailsToSignInOrUp"
        case .fromDetailsToCollectionView:
            return "fromDetailsToCollectionView"
        case .fromDetailsToEmail:
            return "fromDetailsToEmail"

        case .fromCollectionViewToImage:
            return "fromCollectionViewToImage"
        }
    }
}
