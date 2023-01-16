//
//  DetailsCollectionViewCell.swift
//  Plogging
//
//  Created by HONORE Adeline on 16/01/2023.
//

import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    let identifier = "detailsCollectionViewCell"
    
    // MARK: - Init
    
    func configure(image: UIImage) {
        imageView.image = image
    }
}
