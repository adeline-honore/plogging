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
    
    case noPlogging
    
    
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
            
        case .noPlogging:
            return "There is no race in which you participate ."
        }
    }
}
