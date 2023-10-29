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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(plogging: PloggingUI) {
        placeLabel.text = "Place : " + plogging.place
        dateLabel.text = "Departure : " + plogging.dateToDisplayedString(date: plogging.beginning)
        distanceLabel.text = "Distance : " + plogging.distance.fixedFraction(digits: 0) + " km"
        arrowImage.tintColor = Color().appColor
    }
}
