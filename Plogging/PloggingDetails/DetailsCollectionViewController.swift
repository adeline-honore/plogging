//
//  DetailsCollectionViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 16/01/2023.
//

import UIKit

protocol DetailsCollectionDelegate: AnyObject {
    func didSetPhotos(photos: [PhotoUI])
}

class DetailsCollectionViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noImagesLabel: UILabel!
    @IBOutlet weak var setPhotosView: UIView!
    @IBOutlet weak var maxNumberPhotosLabel: UILabel!
    
    // MARK: - Properties
    
    weak var delegate: DetailsCollectionDelegate?
    var photos: [PhotoUI] = [PhotoUI]()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: check authentification
        maxNumberPhotosLabel.isHidden = true
        noImagesLabel.isHidden = true
//        displayCollectionView()
    }
    
    // MARK: - Display Collection View Races
    
    private func displayCollectionView() {
                
        if photos.isEmpty {
            collectionView.isHidden = true
            noImagesLabel.isHidden = false
            noImagesLabel.text = Texts.noImages.value
            noImagesLabel.textColor = Color().appColor
        } else {
            collectionView.isHidden = false
            noImagesLabel.isHidden = true
        }
    }
    
    // MARK: - Set Images
    
    @IBAction func didTapAddPhotosButton() {
        chooseImage(source: .photoLibrary)
    }
    
}


extension DetailsCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCollectionViewCell().identifier, for: indexPath) as! DetailsCollectionViewCell
        
        guard let image = photos[indexPath.row].image else { return DetailsCollectionViewCell() }
        cell.configure(image: image)
        
        return cell
    }
}


extension DetailsCollectionViewController: ChooseImageDelegate {
    func chooseImage(source: UIImagePickerController.SourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = source
        imagePickerController.delegate = self

        present(imagePickerController, animated: true, completion: nil)
    }
}

extension DetailsCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let choosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
                
        let photo = PhotoUI(name: String(photos.count + 1), imageBinary: choosenImage.jpegData(compressionQuality: 1), image: choosenImage)
        
        photos.append(photo)
        
        delegate?.didSetPhotos(photos: photos)
        picker.dismiss(animated: true, completion: nil)
        
        collectionView.reloadData()
    }
    
}
