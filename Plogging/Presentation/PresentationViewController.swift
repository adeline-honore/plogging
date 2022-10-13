//
//  PresentationViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 01/10/2022.
//

import UIKit

class PresentationViewController: UIViewController {

    // MARK: - Properties

    private var presentationView: PresentationView!
    private let segueToFirstGeoLocationVC = "segueToFirstGeoLocationVC"
    
    private let titleText = "Welcome"
    private let explanationText = "explanation"
    private let buttonText = " OK !"
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presentationView = view as? PresentationView
        
        configureView()
        
    }
    
    
    private func configureView() {
        presentationView.titleLabel.text = titleText
        presentationView.explanationLabel.text = explanationText
        
        presentationView.explanationLabel.frame = CGRect(x: 0,
                                                         y: 0,
                                                         width: presentationView.frame.width - 150,
                                                         height: presentationView.frame.height / 2)
        
        
        presentationView.okButton = presentationView.okButton.configureOkButton(title: buttonText, frame: CGRect(x: 0, y: 0, width: presentationView.frame.width - 100, height: (presentationView.frame.width - 100) * 0.2), target: self)
        
    }
    
    
    @IBAction func didTapOkButton() {        
        performSegue(withIdentifier: segueToFirstGeoLocationVC, sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueToFirstGeoLocationVC {
            let vc = segue.destination as! FirstGeoLocationViewController
        }
    }
    
    
}
