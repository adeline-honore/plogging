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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noImagesLabel: UILabel!
    @IBOutlet weak var setPhotosView: UIView!
    @IBOutlet weak var maxNumberPhotosLabel: UILabel!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: DetailsCollectionDelegate?
    var photos: [PhotoUI] = [PhotoUI]()
    var photoToSend: PhotoUI = PhotoUI()
    var ploggingId: String = String()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: check authentification
        displayCollectionView()
    }
    
    // MARK: - Configure Table View
    
    private func configureTableView() {
        let cellNib = UINib(nibName: PhotoTableViewCell.identifier, bundle: .main)
        tableView.register(cellNib, forCellReuseIdentifier: PhotoTableViewCell.identifier)
    }
    
    // MARK: - Display Collection View Races
    
    private func displayCollectionView() {
                
        if photos.isEmpty {
            tableView.isHidden = true
            noImagesLabel.isHidden = false
            maxNumberPhotosLabel.isHidden = true
            addPhotoButton.isHidden = false
            noImagesLabel.text = Texts.noImages.value
            noImagesLabel.textColor = Color().appColor
        } else {
            tableView.isHidden = false
            noImagesLabel.isHidden = true
            if photos.count >= 5 {
                addPhotoButton.isHidden = true
                maxNumberPhotosLabel.isHidden = false
            } else {
                addPhotoButton.isHidden = false
                maxNumberPhotosLabel.isHidden = true
            }
        }
        tableView.reloadData()
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
    
    private func updateTableView(photo: PhotoUI, action: String) {
        switch action {
        case PhotoAction.set.rawValue:
            if let index = photos.firstIndex(where: {$0.name == photo.name}) {
                photos[index] = photo
            } else {
                print("error")
            }
        case PhotoAction.delete.rawValue:
            if let index = photos.firstIndex(where: {$0.name == photo.name}) {
                photos.remove(at: index)
            } else {
                print("error")
            }
        default:
            return
        }
        displayCollectionView()
    }
}

extension PloggingCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier) as? PhotoTableViewCell ?? PhotoTableViewCell()
        guard let image = photos[indexPath.row].image else { return PhotoTableViewCell() }
        cell.photoImage.image = image
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        displayCollectionView()
    }
    
}

extension PloggingCollectionViewController: ImageViewControllerDelegate {
    func setPhoto(photo: PhotoUI, action: String) {
        delegate?.didSetPhoto(photo: photo, action: action)
        updateTableView(photo: photo, action: action)
    }
}
