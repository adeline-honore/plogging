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
            button.setImage(UIImage(systemName: "person.fill.checkmark"), for: .normal)
            button.tintColor = Color().appColor
        } else {
            button.setImage(UIImage(systemName: "person.fill.xmark"), for: .normal)
            button.tintColor = .gray
        }
    }
    
    func manageMessageButtonLabel(button: UIButton, isAdmin: Bool) {
        isAdmin ? button.setTitle(" Send mail for all ploggers ?", for: .normal) : button.setTitle(" Send mail to race's admin ?", for: .normal)
    }
}
