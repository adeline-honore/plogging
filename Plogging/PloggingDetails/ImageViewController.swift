//
//  ImageViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 07/04/2023.
//

import UIKit

class ImageViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var photo: UIImageView!
    var photoUI = PhotoUI()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = photoUI.image
    }
    
    // MARK: - Navigation
    
    
    
}
