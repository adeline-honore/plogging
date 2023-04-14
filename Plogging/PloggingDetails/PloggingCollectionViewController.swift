//
//  DetailsCollectionViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 16/01/2023.
//

import UIKit

protocol DetailsCollectionDelegate: AnyObject {
    func didSetPhoto(photo: PhotoUI, action: String)
}

class PloggingCollectionViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noImagesLabel: UILabel!
    @IBOutlet weak var setPhotosView: UIView!
    @IBOutlet weak var maxNumberPhotosLabel: UILabel!
    
    // MARK: - Properties
    
    weak var delegate: DetailsCollectionDelegate?
    var photos: [PhotoUI] = [PhotoUI]()
    var photoToSend: PhotoUI = PhotoUI()
    var ploggingId: String = String()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: check authentification
        maxNumberPhotosLabel.isHidden = true
        noImagesLabel.isHidden = true
        displayCollectionView()
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
    
    // MARK: - Go to
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.fromCollectionViewToImage.identifier {
            let viewController = segue.destination as? ImageViewController
            viewController?.photoUI = photoToSend
            viewController?.delegate = self
        }
    }

    func sendImage(photoUI: PhotoUI) {
        performSegue(withIdentifier: SegueIdentifier.fromCollectionViewToImage.identifier, sender: nil)
    }
}


extension PloggingCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCollectionViewCell().identifier, for: indexPath) as! DetailsCollectionViewCell
        
        guard let image = photos[indexPath.row].image else { return DetailsCollectionViewCell() }
        cell.configure(image: image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        photoToSend = photos[indexPath.row]
        sendImage(photoUI: photos[indexPath.row])
    }
}


extension PloggingCollectionViewController: ChooseImageDelegate {
    func chooseImage(source: UIImagePickerController.SourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = source
        imagePickerController.delegate = self

        present(imagePickerController, animated: true, completion: nil)
    }
}

extension PloggingCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let choosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        let photo = PhotoUI(name: ploggingId + "&photo:" + String(photos.count + 1), imageBinary: choosenImage.jpegData(compressionQuality: 1), image: choosenImage)
        
        photos.append(photo)
        
        delegate?.didSetPhoto(photo: photo, action: PhotoAction.create.rawValue)
        picker.dismiss(animated: true, completion: nil)
        
        collectionView.reloadData()
    }
    
}

extension PloggingCollectionViewController: ImageViewControllerDelegate {
    func setPhoto(photo: PhotoUI, action: String) {
        delegate?.didSetPhoto(photo: photo, action: action)
    }
}
