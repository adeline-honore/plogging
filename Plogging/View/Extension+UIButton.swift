//
//  Extension+UIButton.swift
//  Plogging
//
//  Created by HONORE Adeline on 02/10/2022.
//

import UIKit


extension UIButton {
    func configureOkButton(title: String, frame: CGRect, target: AnyObject) -> UIButton {
        self.setTitle(title, for: .normal)
        self.tintColor = .green
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 6
        self.layer.borderColor = UIColor.orange.cgColor
        
        self.frame = frame
        
        
        return self
    }
    
}
