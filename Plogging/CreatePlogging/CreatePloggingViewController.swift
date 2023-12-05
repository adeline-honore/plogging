//
//  CreatePloggingViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 14/11/2022.
//

import UIKit
import MapKit

protocol CreatePloggingViewControllerDelegate: AnyObject {
    func ploggingIsCreated(ploggingUICreated: PloggingUI)
}

class CreatePloggingViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: CreatePloggingViewControllerDelegate?

    private var createPloggingView: CreatePloggingView!

    private var ploggingService = PloggingService(network: PloggingNetwork())
    private var imageService = ImageService(network: ImageNetwork())
    private let repository = PloggingCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)

    private var currentPloggingUI: PloggingUI = PloggingUI()
    private var startDate: Date = Date()
    private var startIntegerTimestamp: Int = 0

    private var distanceArray: [String] = []
    private var distanceSelected: String = ""
    private var selectedSearchCompletion: MKLocalSearchCompletion?

    private var localSearchCompletion = LocalSearchCompletion()

    private let popUpModal: PopUpModalViewController = PopUpModalViewController()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        createPloggingView = view as? CreatePloggingView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        displayView()
        }

    private func displayView() {
        if isInternetAvailable() {
            distanceArray = returnDistance()
            distanceSelected = distanceArray[0]

            setupDatePicker()
            createPloggingView.noInternetLabel.isHidden = true
            createPloggingView.mainStack.isHidden = false
            createPloggingView.resultLocationLabel.isHidden = false
            createPloggingView.resultLocationLabel.text = "No place selected"
        } else {
            createPloggingView.noInternetLabel.isHidden = false
            createPloggingView.noInternetLabel.text = AlertType.internetNotAvailable.message
            createPloggingView.mainStack.isHidden = true
            if #available(iOS 16.0, *) {
                navigationItem.rightBarButtonItem?.isHidden = true
            }
        }
    }

    // MARK: - Change Main Image

    @IBAction func didTapChangeImage() {
        chooseImage(source: .photoLibrary)
    }

    // MARK: - Date Picker View

    @IBAction func getDateFromPickerView() {
        startDate = createPloggingView.whenDatePicker.date
        startIntegerTimestamp = Int(createPloggingView.whenDatePicker.date.timeIntervalSince1970)
    }

    func setupDatePicker() {
        createPloggingView.whenDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
        startIntegerTimestamp = Int(createPloggingView.whenDatePicker.date.timeIntervalSince1970)
    }

    // MARK: - Distance Picker View

    private func returnDistance() -> [String] {

        for distanceRange in stride(from: 2, through: 20, by: 2) {
            distanceArray.append(String(distanceRange))
        }
        return distanceArray
    }

    // MARK: - User Tap On Create Plogging

    @IBAction func didTapSavePlogging(_ sender: UIBarButtonItem) {
        savePlogging()
    }

    // MARK: - Create valid Plogging

    private func setPloggingElement() {
        currentPloggingUI.id = "plogging"
        currentPloggingUI.admin = UserDefaults.standard.string(forKey: "emailAddress") ?? ""
        currentPloggingUI.isTakingPart = true
        currentPloggingUI.distance = Int(distanceSelected) ?? 2
        currentPloggingUI.beginningTimestamp = startIntegerTimestamp
        currentPloggingUI.beginningString = PloggingUI().displayUIDateFromIntegerTimestamp(timestamp: startIntegerTimestamp)
        currentPloggingUI.ploggers = [currentPloggingUI.admin]
    }

    private func savePlogging() {

        // set current plogging
        setPloggingElement()

        // Check plogging's place validity
        guard currentPloggingUI.isValid else {
            popUpModal.userAlert(element: .ploggingWithoutPlace, viewController: self)
            return
        }

        // Get coordinates
        localSearchCompletion.getCoordinates(for: selectedSearchCompletion) { [weak self] result in

            guard let self = self else { return }
            switch result {
            case let .success(coordinates):
                guard let latitude = coordinates?.latitude, let longitude = coordinates?.longitude else { return }

                self.currentPloggingUI.latitude = latitude
                self.currentPloggingUI.longitude = longitude
                // create UUID for plogging
//                currentPlogging.id = UUID().uuidString

                let randomInteger = String(Int.random(in: 0..<1000))
                currentPloggingUI.id = "EEZZ-000-24-JAAUG-WWWW" + randomInteger

                // save plogging in APi
                savePloggingInExternalDatabase()
            case .failure:
                popUpModal.userAlert(element: AlertType.createError, viewController: self)
            }
        }
    }

    // MARK: - Save Plogging in API

    private func savePloggingInExternalDatabase() {
        let ploggingToSave: Plogging = Plogging(ploggingUI: currentPloggingUI)
        ploggingService.createOrUpdatePlogging(plogging: ploggingToSave) { result in
            switch result {
            case .success:
                self.saveImageInDistantDataBase()
            case .failure:
                self.popUpModal.userAlert(element: .network, viewController: self)
            }
        }
    }

    private func saveImageInDistantDataBase() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard self.currentPloggingUI.mainImage != nil else { return }

            let mainImageBinary = self.currentPloggingUI.mainImage?.jpegData(compressionQuality: 0.8)

            guard mainImageBinary != nil else { return }

            self.currentPloggingUI.mainImageBinary = mainImageBinary

            imageService.uploadPhoto(mainImageBinary: mainImageBinary!, ploggingId: currentPloggingUI.id) { result in
                switch result {
                case .success:
                    self.internalDatabaseSaveRequest()
                case .failure:
                    self.popUpModal.userAlert(element: .network, viewController: self)
                }
            }
        }
    }

    // MARK: - Save Plogging in Internal DataBase

    private func internalDatabaseSaveRequest() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.repository.createEntity(ploggingUI: self.currentPloggingUI)
                self.navigationController?.popViewController(animated: true)
                self.delegate?.ploggingIsCreated(ploggingUICreated: self.currentPloggingUI)
            } catch {
                self.popUpModal.userAlert(element: AlertType.ploggingNotSaved, viewController: self)
            }
        }
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.fromCreateToLocalSearch.rawValue {
            let overVC = segue.destination as? LocalSearchCompletionViewController
            overVC?.localSearchCompletionViewControllerDelegate = self
        }
    }
}

// MARK: - PickerView

extension CreatePloggingViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return distanceArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return distanceArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        distanceSelected = distanceArray[row]
    }
}

// MARK: - LocalSearchCompletionViewControllerDelegate

extension CreatePloggingViewController: LocalSearchCompletionViewControllerDelegate {
    func departurePlaceChoosen(result: MKLocalSearchCompletion) {
        createPloggingView.resultLocationLabel.text = result.title
        selectedSearchCompletion = result
        currentPloggingUI.place = result.title
    }
}

// MARK: - UIImagePickerControllerDelegate

extension CreatePloggingViewController: ChooseImageDelegate {
    func chooseImage(source: UIImagePickerController.SourceType) {

        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = source
        imagePickerController.delegate = self

        present(imagePickerController, animated: true, completion: nil)
    }
}

extension CreatePloggingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        guard let choosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }

        currentPloggingUI.mainImage = choosenImage

        picker.dismiss(animated: true, completion: nil)
    }
}
