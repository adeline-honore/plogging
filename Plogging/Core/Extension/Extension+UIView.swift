//
//  Extension+UIView.swift
//  Plogging
//
//  Created by HONORE Adeline on 17/11/2022.
//

import Foundation
import UIKit


extension UIView {
    
    func manageIsTakingPartButton(button: UIButton, isTakingPart: Bool) {
        if isTakingPart {
            button.setImage(UIImage(systemName: "person.fill.checkmark"), for:.normal)
            button.tintColor = Color().appColor
        } else {
            button.setImage(UIImage(systemName: "person.fill.xmark"), for:.normal)
            button.tintColor = .gray
        }
    }
    
    func displayDate(dateString:String) -> String {
        var toDisplay: String = dateString
        toDisplay = toDisplay.replacingOccurrences(of: " ",
                                                    with: " at ")
        
        toDisplay = toDisplay.replacingOccurrences(of: ":",
                                                   with: "h")
        
        return toDisplay
    }
}
