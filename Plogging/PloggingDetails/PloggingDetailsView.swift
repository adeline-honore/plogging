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
    @IBOutlet weak var isTakingPartButton: UIButton!
    @IBOutlet weak var dateAndHourLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var adminNameTextLabel: UILabel!
    @IBOutlet weak var adminNameLabel: UILabel!
    @IBOutlet weak var ploggerList: UILabel!
}

extension PloggingDetailsView {
    // MARK: - Configure Plogging Details View

    func configure(plogging: PloggingUI, isAdmin: Bool) {

        // @IBOutlet informations
        mainImage.image = plogging.mainImage
        dateAndHourLabel.text = plogging.dateToDisplayedString(date: plogging.beginning)
        placeLabel.text = plogging.place
        adminNameLabel.text = plogging.admin
        messageButton.tintColor = Color().appColor
        manageIsTakingPartButton(button: isTakingPartButton, isTakingPart: plogging.isTakingPart)
        manageMessageButtonLabel(button: messageButton, isAdmin: isAdmin)

        // Manage display @IBOutlet
        adminNameTextLabel.isHidden = isAdmin
        adminNameLabel.isHidden = isAdmin
        editMainImageButton.isHidden = !isAdmin
        isTakingPartButton.isHidden = isAdmin
        ploggerList.isHidden = !isAdmin
        ploggerList.text = "Ploggers : \(plogging.ploggers?.count ?? 1)"
    }
}
