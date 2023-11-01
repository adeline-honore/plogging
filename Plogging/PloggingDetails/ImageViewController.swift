//
//  ImageViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 07/04/2023.
//

//import UIKit
//
//protocol ImageViewControllerDelegate: AnyObject {
//    func setPhoto(photo: PhotoUI, action: String)
//}
//
//class ImageViewController: UIViewController {
//
//    // MARK: - Properties
//
//    @IBOutlet weak var photo: UIImageView!
//    var photoUI = PhotoUI()
//    weak var delegate: ImageViewControllerDelegate?
//
//    // MARK: - Init
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        photo.image = photoUI.image
//    }
//
//    // MARK: - Set Photo
//
//    @IBAction func didTapSetButton() {
//        if isInternetAvailable() {
//            setPhoto()
//        } else {
//            PopUpModalViewController().userAlert(element: .unableToSaveChangeInternet, viewController: self)
//        }
//    }
//
//    private func setPhoto() {
//        chooseImage(source: .photoLibrary)
//    }
//
//    // MARK: - Delete Photo
//
//    @IBAction func didTapDeleteButton() {
//        if isInternetAvailable() {
//            deletePhoto()
//        } else {
//            PopUpModalViewController().userAlert(element: .unableToSaveChangeInternet, viewController: self)
//        }
//    }
//
//    private func deletePhoto() {
//        delegate?.setPhoto(photo: photoUI, action: PhotoAction.delete.rawValue)
//        self.dismiss(animated: true)
//    }
//
//    // MARK: - Cancel View Controller
//
//    @IBAction func didTapCancelButton() {
//        self.dismiss(animated: true)
//    }
//}
//
//extension ImageViewController: ChooseImageDelegate {
//    func chooseImage(source: UIImagePickerController.SourceType) {
//
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.sourceType = source
//        imagePickerController.delegate = self
//
//        present(imagePickerController, animated: true, completion: nil)
//    }
//}
//
//extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//
//        guard let choosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
//            return
//        }
//
//        photoUI.image = choosenImage
//        photoUI.imageBinary = choosenImage.jpegData(compressionQuality: 1)
//
//        photo.image = choosenImage
//
//        delegate?.setPhoto(photo: photoUI, action: PhotoAction.set.rawValue)
//        picker.dismiss(animated: true, completion: nil)
//        self.dismiss(animated: true)
//    }
//}
