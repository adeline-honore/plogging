//
//  PhotoTableViewCell.swift
//  Plogging
//
//  Created by HONORE Adeline on 14/04/2023.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet weak var photoImage: UIImageView!
    static let identifier = "PhotoTableViewCell"

    // MARK: - Init

    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = bounds
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
