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
    
    private let viewModels: [CollectionTableViewCellViewModel] = [
        CollectionTableViewCellViewModel(
            viewModels: [
                TileCollectionViewCellViewModel(name: "Onglet 1", backgroundColor: .systemBlue),
                TileCollectionViewCellViewModel(name: "Onglet 2", backgroundColor: .systemRed),
                TileCollectionViewCellViewModel(name: "Onglet 3", backgroundColor: .systemGray)
            ]
        )
    ]
    
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viewModel = viewModels[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else {
            fatalError()
        }
        
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width
    }
}
