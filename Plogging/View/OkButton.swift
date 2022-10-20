//
//  OkButton.swift
//  Plogging
//
//  Created by HONORE Adeline on 17/10/2022.
//

import UIKit

class OkButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 3
        layer.borderColor = UIColor.orange.cgColor
        
        titleLabel?.textAlignment = .center
        tintColor = .purple
    }
}
