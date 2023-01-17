//
//  DetailsCollectionViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 16/01/2023.
//

import UIKit

class DetailsCollectionViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noImagesLabel: UILabel!
    
    // MARK: - Properties
    
    var images: [UIImage?] = [UIImage?]()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayCollectionView()
    }
    
    // MARK: - Display Collection View Races
    
    private func displayCollectionView() {
                
        if images.isEmpty {
            collectionView.isHidden = true
            noImagesLabel.isHidden = false
            noImagesLabel.text = Texts.noImages.value
            noImagesLabel.textColor = Color().appColor
        } else {
            collectionView.isHidden = false
            noImagesLabel.isHidden = true
        }
    }
    
}


extension DetailsCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCollectionViewCell().identifier, for: indexPath) as! DetailsCollectionViewCell
        
        
        guard let image = images[indexPath.row] else { return DetailsCollectionViewCell() }
        
        cell.configure(image: image)
        
        return cell
    }
}
