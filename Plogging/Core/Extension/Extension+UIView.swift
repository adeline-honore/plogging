//
//  Extension+UIView.swift
//  Plogging
//
//  Created by HONORE Adeline on 17/11/2022.
//

import Foundation
import UIKit

extension UIView {
        func manageIsTakingPartSwitch(switchButton: UISwitch, isTakingPart: Bool) {
            switchButton.setOn(isTakingPart, animated: true)
            switchButton.onTintColor = Color().appColor
    }

    func manageMessageButtonLabel(button: UIButton, isAdmin: Bool) {
        isAdmin ? button.setTitle(" Send mail for all ploggers ?", for: .normal) : button.setTitle(" Send mail to race's admin ?", for: .normal)
    }
}
