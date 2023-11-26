//
//  Texts.swift
//  Plogging
//
//  Created by HONORE Adeline on 05/11/2022.
//

import Foundation

enum Texts {

    case onBoardingTitle
    case onBoardingTabOne
    case onBoardingTabTwo
    case onBoardingTabThree
    case onBoardingButton
    
    case internetIsUnavailable

    case noPlogging

    case noImages

    case newEmailSentence

    case haveToLoginMessage
    case haveToLoginMessageNoInternet

    case ploggingUpDateError

    case takePart
    case duration

    var value: String {
        switch self {
        case .onBoardingTitle:
            return "Welcome \nto the new app \nPlogging"
        case .onBoardingTabOne:
            return "Ploging means \nrunning and \ncollect trash"
        case .onBoardingTabTwo:
            return "You can \nparticipate in Plogging races \nand create new ones"
        case .onBoardingTabThree:
            return "Let's go \nand \nclean Earth !!"
        case .onBoardingButton:
            return "OK !"
            
        case .internetIsUnavailable:
            return "No internet connection ."

        case .noPlogging:
            return "There is no race in which you participate ."

        case .noImages:
            return "There isn't images for this race ."

        case .newEmailSentence:
            return "Please, enter an email address to participate at this race ."

        case .haveToLoginMessage:
            return "Please, log in to acces to this page"
        case .haveToLoginMessageNoInternet:
            return "Please, log in to acces to this page when internet will be available"

        case .ploggingUpDateError:
            return "Impossible to update your ploggings"

        case .takePart:
            return "Take part at this plogging"
            
        case .duration:
            return "approximate duration of the race : "
        }
    }
}
