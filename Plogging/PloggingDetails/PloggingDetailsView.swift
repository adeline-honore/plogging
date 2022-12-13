//
//  PloggingDetailsView.swift
//  Plogging
//
//  Created by HONORE Adeline on 07/11/2022.
//

import UIKit

class PloggingDetailsView: UIView {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var isTakingPartButton: UIButton!
    @IBOutlet weak var dateAndHourLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var adminNameLabel: UILabel!
    @IBOutlet weak var editMainImageButton: UIButton!
}


extension PloggingDetailsView {
    func configure(plogging: PloggingUI) {
        
        if mainImage.image == nil {
            mainImage.image = UIImage(named: "icon")
        } else {
            mainImage.image = plogging.mainImage
        }
        
        dateAndHourLabel.text = plogging.dateToDisplayedString(date: plogging.beginning)
        placeLabel.text = plogging.place
        adminNameLabel.text = plogging.admin
        
        photosButton.tintColor = Color().appColor
        messageButton.tintColor = Color().appColor
        manageIsTakingPartButton(button: isTakingPartButton, isTakingPart: plogging.isTakingPart)
    }
}
