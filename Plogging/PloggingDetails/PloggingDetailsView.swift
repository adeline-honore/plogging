//
//  PloggingDetailsView.swift
//  Plogging
//
//  Created by HONORE Adeline on 07/11/2022.
//

import UIKit

class PloggingDetailsView: UIView {

    // MARK: - @IBOutlet

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var editMainImageButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var isTakingPartLabel: UILabel!
    @IBOutlet weak var isTakingPartSwitch: UISwitch!
    @IBOutlet weak var dateAndHourLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var adminNameTextLabel: UILabel!
    @IBOutlet weak var adminNameLabel: UILabel!
    
    @IBOutlet weak var ploggerList: UILabel!
}

extension PloggingDetailsView {
    // MARK: - Configure Plogging Details View

    func configure(plogging: PloggingUI, isAdmin: Bool) {

        // @IBOutlet informations
        mainImage.image = plogging.mainImage
        dateAndHourLabel.text =  plogging.beginningString
        placeLabel.text = plogging.place
        adminNameLabel.text = plogging.admin
        messageButton.tintColor = Color().appColor
        manageIsTakingPartSwitch(switchButton: isTakingPartSwitch, isTakingPart: plogging.isTakingPart)
        manageMessageButtonLabel(button: messageButton, isAdmin: isAdmin)
        durationLabel.text = getPloggingDuration(distance: plogging.distance)
        editMainImageButton.layer.cornerRadius = 25
        isTakingPartLabel.text = Texts.takePart.value
        distanceLabel.text = "Distance : \(plogging.distance)km"

        // Manage display @IBOutlet
        adminNameTextLabel.isHidden = isAdmin
        adminNameLabel.isHidden = isAdmin
        editMainImageButton.isHidden = !isAdmin
        isTakingPartSwitch.isHidden = isAdmin
        isTakingPartLabel.isHidden = isAdmin
        
        ploggerList.text = "Ploggers : \(plogging.ploggers.count )"
    }
}
