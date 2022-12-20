//
//  Extension+View.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/12/2022.
//

import UIKit

extension UIView {
    // MARK: - Turning plain square image to circle image
    func circleImageRounded(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
    }
}
