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
    
    
    
    
    
    var value: String {
        switch self {
        case .onBoardingTitle:
            return "Welcome"
        case .onBoardingTabOne:
            return "Ploging means running and collect trash."
        case .onBoardingTabTwo:
            return "You can go participate at Plogging races and create others"
        case .onBoardingTabThree:
            return "Let's go and clean Earth !!"
        case .onBoardingButton:
            return "OK !"
        }
    }
}
