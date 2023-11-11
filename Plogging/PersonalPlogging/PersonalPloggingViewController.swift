//
//  PersonalPloggingViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 14/11/2022.
//

import UIKit

class PersonalPloggingViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noPloggingLabel: UILabel!
    @IBOutlet weak var haveToLoginView: UIView!
    @IBOutlet weak var haveToLoginTextLabel: UILabel!
    @IBOutlet weak var haveToLoginButton: UIButton!
    @IBOutlet weak var networkErrorLabel: UILabel!

    // MARK: - Properties

    private var ploggingService = PloggingService()

    private let repository = PloggingCoreDataManager(
        coreDataStack: CoreDataStack(),
        managedObjectContext: CoreDataStack().viewContext)

    private var isConnectedUser: Bool = false

    private var ploggingsUI: [PloggingUI] = []
    private var ploggingsSection: [[PloggingUI]] = [[], []]
    private var ploggingUI: PloggingUI?

    private var dateNowInteger: Date = Date()

    private let icon = UIImage(imageLiteralResourceName: "icon")

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.delegate = self
        tableView.dataSource = self
        isConnectedUser = UserDefaults.standard.string(forKey: "emailAddress") != nil

        activityIndicator.isHidden = false
        tableView.isHidden = true
        noPloggingLabel.isHidden = true
        haveToLoginView.isHidden = true
        haveToLoginTextLabel.isHidden = true
        haveToLoginButton.isHidden = true
        networkErrorLabel.isHidden = true
        
        if !isInternetAvailable() && !isConnectedUser {
            screenWhenInternetIsUnavailable()
            screenWhenUserIsNotConnected()
        } else if !isInternetAvailable() && isConnectedUser {
            screenWhenUserIsNotConnected()
            displayPloggingFromCoreData()
        } else {
            getPersonalPloggings()
        }
    }
    
    // MARK: - If Internet Unavailable

    private func screenWhenInternetIsUnavailable() {
        activityIndicator.isHidden = true
        networkErrorLabel.isHidden = false
    }
    
    // MARK: - If User Is Not Connected

    private func screenWhenUserIsNotConnected() {
        activityIndicator.isHidden = true
        haveToLoginView.isHidden = false
        haveToLoginTextLabel.isHidden = false
        haveToLoginButton.isHidden = false
    }

    // MARK: - Display Personal Races

    private func displayPersonalPloggings() {

        if !ploggingsUI.isEmpty {
            tableView.isHidden = false
            createDataSection()
            tableView.reloadData()
            configureTableView()
        } else {
            noPloggingLabel.isHidden = false
            noPloggingLabel.text = Texts.noPlogging.value
            noPloggingLabel.textColor = Color().appColor
        }
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    private func getPersonalPloggings() {

        ploggingService.load { result in
            switch result {
            case .success(let ploggingsResult):
                self.getPersonnalPloggingList(ploggingList: ploggingsResult)
            case .failure:
                self.networkErrorLabel.isHidden = false
                self.networkErrorLabel.text = Texts.ploggingUpDateError.value
                self.displayPloggingFromCoreData()
            }
        }
    }

    private func getPersonnalPloggingList(ploggingList: [Plogging]) {
        var ploggings: [Plogging] = []

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let emailAddress = UserDefaults.standard.string(forKey: "emailAddress") else { return }

            ploggingList.forEach { item in
                if item.ploggers.contains(emailAddress) {
                    ploggings.append(item)
                }
            }
            
            var imageList: [PloggingImage] = []
            
            ploggingsUI = ploggings.map{ PloggingUI(plogging: $0, beginning: $0.stringDateToDateObject(dateString: $0.beginning), image:  self.associateImageToPloggingUI(images: imageList, ploggindId: $0.id)) }
            displayPersonalPloggings()
            self.savePloggingListInCoreData(ploggingUIList: ploggingsUI)
        }
    }
    
    private func associateImageToPloggingUI(images: [PloggingImage], ploggindId: String) -> UIImage {

        guard let image = images.first(where: { $0.id == ploggindId })?.mainImage else { return icon}
        return image
    }

    // MARK: - Save Personal Races in CoreData

    private func savePloggingListInCoreData(ploggingUIList: [PloggingUI]) {

        let ploggingUIListFromCD: [PloggingUI] = getPloggingFromCoreData()

        let newPloggingsToSaveInCD = zip(ploggingUIList, ploggingUIListFromCD).enumerated().filter() {
            $1.0.id == $1.1.id
        }.map{$0.0}

        var indexOfPloggingList: Int = 0
        ploggingUIList.forEach { ploggingUI in
            
            if newPloggingsToSaveInCD.contains(indexOfPloggingList) {
                do {
                    try repository.createEntity(ploggingUI: ploggingUI)
                } catch {
                    print("fatalError")
                }
            } else {
                do {
                    try repository.setEntity(ploggingUI: ploggingUI)
                } catch {
                    print("fatalError")
                }
            }
            indexOfPloggingList += 1
        }
    }
    
    // MARK: - Get Personal Races from CoreData

    private func getPloggingFromCoreData() -> [PloggingUI] {
        var ploggingUIList: [PloggingUI] = []
        do {
            let ploggingsCD = try repository.getEntities()
            ploggingUIList = ploggingsCD.map { PloggingUI(
                ploggingCD: $0,
                beginning: repository.stringDateToDateObject(dateString: $0.beginning ?? ""),
                image: UIImage(data: $0.imageBinary ?? Data()) ?? icon
                )
            }
        } catch {
            print("fatalError")
        }
        return ploggingUIList
    }

    // MARK: - Display Personal Races from CoreData

    private func displayPloggingFromCoreData() {
        ploggingsUI = getPloggingFromCoreData()
    }

    private func photosCDToPhotosUI(photosCD: [Any]) -> [PhotoUI]? {
        if !photosCD.isEmpty {
            var photos = [PhotoUI]()

            photosCD.forEach { element in
                let photo: PhotoUI = PhotoUI(name: (element as AnyObject).name, imageBinary: (element as AnyObject).imageBinary, image: UIImage(data: (element as AnyObject).imageBinary ?? Data()))

                photos.append(photo)
            }
            return photos
        }
        return nil
    }

    // MARK: - Configure Table View

    private func configureTableView() {
        let cellNib = UINib(nibName: PloggingTableViewCell.identifier, bundle: .main)
        tableView.register(cellNib, forCellReuseIdentifier: PloggingTableViewCell.identifier)
    }

    // MARK: - Configure data with sections

    private func createDataSection() {
        ploggingsSection = [[], []]

        ploggingsUI.forEach { race in
            let date =  race.beginning

            if date > dateNowInteger {
                // upcoming races
                ploggingsSection[0].append(race)
            } else {
                // past races
                ploggingsSection[1].append(race)
            }
        }
    }

    // MARK: - Go To Plogging Details

    func sendPloggingUI() {
        performSegue(withIdentifier: SegueIdentifier.fromPersonalToDetails.identifier, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.fromPersonalToDetails.identifier {
            let viewController = segue.destination as? PloggingDetailsViewController
            viewController?.ploggingUI = ploggingUI
        } else if segue.identifier == SegueIdentifier.fromPersonalToSignInOrUp.identifier {
            _ = segue.destination as? SignInOrUpViewController
        }
    }

    // MARK: - Go To Log in

    @IBAction func didTapOnLoginButton() {
        performSegue(withIdentifier: SegueIdentifier.fromPersonalToSignInOrUp.identifier, sender: nil)
    }

}

// MARK: - Extension for UITableView

extension PersonalPloggingViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0

        if ploggingsSection[section].isEmpty {
            height = 0
        } else {
            height = 20.0
        }
        return height
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        ploggingsSection.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ploggingsSection[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PloggingTableViewCell.identifier) as? PloggingTableViewCell ?? PloggingTableViewCell()

        if !ploggingsSection.isEmpty {
            cell.configure(plogging: ploggingsSection[indexPath.section][indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ploggingUI = ploggingsSection[indexPath.section][indexPath.row]
        sendPloggingUI()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "upcoming ploggings" : "past ploggings"
    }
}
