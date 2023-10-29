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

    private let repository = PloggingCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)

    private var currentPlogging: PloggingUI = PloggingUI()
    private var startDate: Date = Date()

    private var distanceArray: [String] = []
    private var distanceSelected: String = ""
    private var selectedSearchCompletion: MKLocalSearchCompletion?

    private var localSearchCompletion = LocalSearchCompletion()

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
        guard currentPlogging.isValid else {
            userAlert(element: .ploggingWithoutPlace)
            return
        }

        // Get coordinates
        localSearchCompletion.getCoordinates(for: selectedSearchCompletion) { [weak self] result in

            guard let self = self else { return }

            switch result {
            case let .success(coordinates):
                self.currentPlogging.latitude = coordinates?.latitude
                self.currentPlogging.longitude = coordinates?.longitude
                // TODO: save into CoreData
                do {
                    try self.repository.createEntity(ploggingUI: self.currentPlogging)
                    // TO DO send ploggingUI in cloud
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.ploggingIsCreated(ploggingUICreated: self.currentPlogging)
                } catch {
                    self.userAlert(element: AlertType.ploggingNotSaved)
                }
            case let .failure(error):
                print(error)
                self.userAlert(element: AlertType.createError)
            }
        }
    }

    private func setPloggingElement() {
        let randomInt = Int.random(in: 0...1000)
        currentPlogging.id = "plogging \(randomInt)"
        currentPlogging.admin = "admin \(randomInt)"
        currentPlogging.ploggers = ["admin\(randomInt)"]
        currentPlogging.isTakingPart = true
        currentPlogging.distance = Double(distanceSelected) ?? 2

        guard let image = currentPlogging.mainImage else { return }
        if currentPlogging.mainImage != nil {
            currentPlogging.mainImageBinary = image.jpegData(compressionQuality: 1)
        }
    }

    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.fromCreateToLocalSearch.identifier {
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
        currentPlogging.place = result.title
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

        currentPlogging.mainImage = choosenImage

        picker.dismiss(animated: true, completion: nil)
    }
}
