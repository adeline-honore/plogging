//
//  Extension+UIView.swift
//  Plogging
//
//  Created by HONORE Adeline on 17/11/2022.
//

import Foundation
import UIKit


extension UIView {
    
    func manageIsTakingPartButtonColor(button: UIButton, isTakingPart: Bool) {
        button.tintColor = isTakingPart ? .orange : .gray
    }
    
    func manageIsTakingPartButtonText(button: UIButton, isTakingPart: Bool) {
        button.tintColor = isTakingPart ? .orange : .gray
    }
}
