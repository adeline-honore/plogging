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
    
    // MARK: - Properties
    
    var images: [UIImage?] = [UIImage?]()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
