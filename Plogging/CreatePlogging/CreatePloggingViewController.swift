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

    private var ploggingService = PloggingService()
    private let repository = PloggingCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)

    private var currentPloggingUI: PloggingUI = PloggingUI()
    private var startDate: Date = Date()

    private var distanceArray: [String] = []
    private var distanceSelected: String = ""
    private var selectedSearchCompletion: MKLocalSearchCompletion?

    private var localSearchCompletion = LocalSearchCompletion()
    
    private let popUpModal: PopUpModalViewController = PopUpModalViewController()


    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        createPloggingView = view as? CreatePloggingView
        displayView()
    }

    private func displayView() {
        if isInternetAvailable() {
            distanceArray = returnDistance()
            distanceSelected = distanceArray[0]

            setupDatePicker()
            createPloggingView.noInternetLabel.isHidden = true
            createPloggingView.mainStack.isHidden = false
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
    }

    func setupDatePicker() {
        createPloggingView.whenDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
    }

    // MARK: - Distance Picker View

    private func returnDistance() -> [String] {

        for distanceRange in stride(from: 2, through: 20, by: 2) {
            distanceArray.append(String(distanceRange))
        }
        return distanceArray
    }

    // MARK: - Save as PloggingCD

    @IBAction func didTapSavePlogging(_ sender: UIBarButtonItem) {
        savePlogging()
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
                self.currentPloggingUI.latitude = coordinates?.latitude
                self.currentPloggingUI.longitude = coordinates?.longitude
                // create UUID for plogging
//                currentPlogging.id = UUID().uuidString
                
                let gggg = String(Int.random(in: 0..<1000))
                currentPloggingUI.id = "EEZZ-000-24-JAAUG-WWWW" + gggg
                
                distantDatabaseSaveRequest()
            case .failure:
                popUpModal.userAlert(element: AlertType.createError, viewController: self)
            }
        }
    }
    
    private func distantDatabaseSaveRequest() {
        DispatchQueue.main.async { [weak self] in
            self?.ploggingService.load { result in
                guard let self else { return }
                    switch result {
                    case .success(let array):
                        self.updatePloggingData(array: array)
                    case .failure:
                        self.popUpModal.userAlert(element: .network, viewController: self)
                    }
            }
        }
    }
    
    private func updatePloggingData(array: [Plogging]) {
        var ploggingList = array
        
        var currentPlogging = Plogging()
        currentPlogging.id = currentPloggingUI.id
        currentPlogging.admin = currentPloggingUI.admin
        currentPlogging.beginning = convertDateToString(date: currentPloggingUI.beginning)
        currentPlogging.latitude = currentPloggingUI.latitude ?? 0.0
        currentPlogging.longitude = currentPloggingUI.longitude ?? 0.0
        currentPlogging.ploggers = [currentPloggingUI.admin]
        currentPlogging.distance = Int(currentPloggingUI.distance)
        
        
        ploggingList.append(currentPlogging)
        
        ploggingService.savePloggingRequest(ploggingArray: ploggingList) { result in
                switch result {
                case .success:
                    self.internalDatabaseSaveRequest()
                case .failure:
                    self.popUpModal.userAlert(element: .network, viewController: self)
            }
        }
    }
    
    private func convertDateToString(date: Date) -> String {
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
//        dateFormatter.dateFormat = "YY, MMM d, hh:mm"
        dateFormatter.dateFormat = "d MMM YY, hh:mm"

        // Convert Date to String
        return dateFormatter.string(from: date)
    }
    
    
    private func internalDatabaseSaveRequest() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            do {
                try self.repository.createEntity(ploggingUI: self.currentPloggingUI)
                self.navigationController?.popViewController(animated: true)
                self.delegate?.ploggingIsCreated(ploggingUICreated: self.currentPloggingUI)
            } catch {
                popUpModal.userAlert(element: AlertType.ploggingNotSaved, viewController: self)
            }
        }
    }

    private func setPloggingElement() {
        currentPloggingUI.id = "plogging"
        currentPloggingUI.admin = UserDefaults.standard.string(forKey: "emailAddress") ?? ""
//        currentPloggingUI.ploggers = [UserDefaults.standard.string(forKey: UserDefaultsName.emailAddress.rawValue) ?? ""]
        currentPloggingUI.isTakingPart = true
        currentPloggingUI.distance = Double(distanceSelected) ?? 2

        guard let image = currentPloggingUI.mainImage else { return }
        if currentPloggingUI.mainImage != nil {
            currentPloggingUI.mainImageBinary = image.jpegData(compressionQuality: 1)
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
