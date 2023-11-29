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
        button.setTitle(isAdmin ? " Send mail for all ploggers ?" : " Send mail to race's admin ?", for: .normal)
    }

    func getPloggingDuration(distance: Int) -> String {
        let durationDouble: Double = Double(Double(distance) / 4)
        var durationString: String = String()

        if durationDouble == 0.5 {
            durationString = "30 min"
        } else {
            durationString = String(durationDouble)
            durationString = durationString.replacingOccurrences(of: ".", with: "h")
            durationString = durationString.replacingOccurrences(of: "h0", with: "h")
            durationString = durationString.replacingOccurrences(of: "h5", with: "h30")
        }
        return Texts.duration.value + durationString
    }
}
