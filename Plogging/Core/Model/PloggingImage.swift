//
//  PloggingImage.swift
//  Plogging
//
//  Created by adeline honore on 11/11/2023.
//

import UIKit

struct PloggingImage {
    var id: String
    var mainImage: UIImage?

    // init for create an instance of PloggingImage
    init(id: String? = nil,
         mainImage: UIImage? = nil) {
        self.id = id ?? ""
        self.mainImage = mainImage ?? UIImage(imageLiteralResourceName: "icon")
    }

}
