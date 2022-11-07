//
//  PloggingDetailsViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/10/2022.
//

import UIKit

class PloggingDetailsViewController: UIViewController {

    // MARK: - Properties
    
    var ploggingUI: PloggingUI?
    var ploggingsUI: [PloggingUI]?
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(ploggingUI?.admin)
    }
}
