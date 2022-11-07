//
//  TileCollectionViewCell.swift
//  Plogging
//
//  Created by HONORE Adeline on 04/11/2022.
//

import UIKit

struct TileCollectionViewCellViewModel {
    let name: String
    let backgroundColor: UIColor
}


class TileCollectionViewCell: UICollectionViewCell {
    
    static let identifier =  "TileCollectionViewCell"
    
    @IBOutlet weak var label: UILabel!
    
    
    // MARK: - Init
    
    func configure (with viewModel: TileCollectionViewCellViewModel) {
        contentView.backgroundColor = viewModel.backgroundColor
        
        label.text = viewModel.name
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
            let targetSize = CGSize(width: layoutAttributes.frame.width, height: 340)
        
            //layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        
            return layoutAttributes
        }
}
