//
//  PloggingTableViewCell.swift
//  Plogging
//
//  Created by HONORE Adeline on 15/11/2022.
//

import UIKit

class PloggingTableViewCell: UITableViewCell {

    // MARK: - IBOutlets & properties

    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!

    static let identifier = "PloggingTableViewCell"

    // MARK: - Init

    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = bounds
    }

    func configure(plogging: PloggingUI) {
        placeLabel.text = "Place : " + plogging.place
        dateLabel.text = "Departure : " + plogging.beginningString
        distanceLabel.text = "Distance : " + String(plogging.distance) + " km"
        arrowImage.tintColor = Color().appColor
    }
}
