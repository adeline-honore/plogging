//
//  ChooseImageDelegate.swift
//  Plogging
//
//  Created by HONORE Adeline on 17/01/2023.
//

import UIKit

protocol ChooseImageDelegate: AnyObject {
    func chooseImage(source: UIImagePickerController.SourceType)
}
