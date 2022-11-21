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
    
    func timestampToString(timestamp: Double) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        
        // Set Locale
        formatter.locale = Locale(identifier: "fr")
        
        return formatter.string(from: date)
    }
}
