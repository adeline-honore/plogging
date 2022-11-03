//
//  PresentationViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 01/10/2022.
//

import UIKit

protocol PresentationViewControllerDelegate: AnyObject {
    func didPressDismissButton()
}


class PresentationViewController: UIViewController {

    // MARK: - Properties

    private var presentationView: PresentationView!
    
    private let titleText = "Welcome"
    private let explanationText = "explanation"
    private let buttonText = " OK !"
    
    weak var delegate: PresentationViewControllerDelegate?
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presentationView = view as? PresentationView
        
        configureView()
        
        _ = self.view
    }
    
    
    private func configureView() {
        presentationView.titleLabel.text = titleText
        presentationView.okButton.titleLabel?.text = buttonText
    }
    
    
    @IBAction func didTapOkButton() {
        dismiss(animated: true, completion: nil)
        delegate?.didPressDismissButton()
    }
    
}


extension PresentationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
