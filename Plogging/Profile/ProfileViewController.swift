//
//  ProfileViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/12/2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var profileView: ProfileView!
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView = view as? ProfileView
        profileView.configure()
    }
}
