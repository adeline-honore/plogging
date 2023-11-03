//
//  AlertType.swift
//  Plogging
//
//  Created by HONORE Adeline on 09/10/2022.
//

import Foundation

enum AlertType {
    
    case welcomeMessage
    case logOut

    case locationSaved
    case locationNotSaved

    case ploggingSaved
    case ploggingNotSaved
    case ploggingWithoutPlace
    case createError

    case internalDatabase
    case network

    case isTakingPart
    case isNotTakingPart

    case mailAppUnavailable

    case internetNotAvailable
    case unableToSaveChangeInternet
    case unableToCreate
    case unableToCreateUser

    case unavailableEmail
    case invalidEmail

    case haveToLogin

    case emptyIdentifier

    case wantToParticipate
    case wantToNoParticipate
    case ploggingSetWithSuccess

    var message: String {
        switch self {
        case .welcomeMessage:
            return "Welcome in the community of ploggers :-)"
        case .logOut:
            return "Are you sure that you want to log out ?"
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
        case .createError:
            return "An error occured . Please try again ."

        case .internalDatabase:
            return "Oups ! Internal Memory troubles ."
        case .network:
            return "Oups ! Network troubles ."

        case .isTakingPart:
            return "Yeah ! You will participate at this plogging ."
        case .isNotTakingPart:
            return "Ok ! You will not take part at this plogging ."

        case .mailAppUnavailable:
            return "Mail app unavailable . Please try for yourself ."

        case .internetNotAvailable:
            return "Oups ! No internet connection ."
        case .unableToSaveChangeInternet:
            return "Unable to save change. There is no internet connection ."
        case .unableToCreate:
            return "Unable to create Plogging. There is no internet connection"
        case .unableToCreateUser:
            return "Unable to create user. Please try again later ."

        case .unavailableEmail:
            return "Please, enter an email address ."
        case .invalidEmail:
            return "Please, enter a valid email address ."

        case .haveToLogin:
            return "You have to be log in order to open this function. Do you want to log in ?"

        case .emptyIdentifier:
            return "Fields not filled in"

        case .wantToParticipate:
            return "Do you want to participate in this plogging ?"
        case .wantToNoParticipate:
            return "Do you want to cancel your participation in this race?"
        case .ploggingSetWithSuccess:
            return "Plogging has been set with success"
        }
    }

    var title: String {
        switch self {
        case .haveToLogin:
            return "Oups !"
        default:
            return ""
        }
    }
}
