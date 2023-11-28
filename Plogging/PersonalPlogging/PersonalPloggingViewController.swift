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

    private var networkService = NetworkService(network: Network())

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
            screenWhenInternetIsUnavailable()
            displayPloggingFromCoreData()
        } else if isInternetAvailable() && !isConnectedUser {
            screenWhenUserIsNotConnected()
        } else {
            getAPIPloggingList()
        }
    }

    // MARK: - If Internet Unavailable

    private func screenWhenInternetIsUnavailable() {
        activityIndicator.isHidden = true
        networkErrorLabel.isHidden = false
        networkErrorLabel.text = Texts.internetIsUnavailable.value
    }

    // MARK: - If User Is Not Connected

    private func screenWhenUserIsNotConnected() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        haveToLoginView.isHidden = false
        haveToLoginTextLabel.text = isInternetAvailable() ? Texts.haveToLoginMessage.value : Texts.haveToLoginMessageNoInternet.value
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

    private func getAPIPloggingList() {
        networkService.getAPIPloggingList { result in
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            ploggingsUI = ploggingList.map { PloggingUI(plogging: $0, scheduleTimestamp: $0.beginning, scheduleString: PloggingUI().displayUIDateFromIntegerTimestamp(timestamp: $0.beginning), isTakingPartUI: self.isUserTakingPart(ploggingPloggers: $0.ploggers))}

            ploggingsUI = ploggingsUI.filter({ $0.isTakingPart == true
            })

            if ploggingsUI.isEmpty {
                displayPersonalPloggings()
            } else {
                getPersonnalPloggingMainImage()
            }
        }
    }

    private func getPersonnalPloggingMainImage() {
        for personnalPlogging in ploggingsUI {
            guard let ploggingsIndex = self.ploggingsUI.firstIndex(where: { $0.id == personnalPlogging.id}) else { return }

            networkService.getPloggingImage(ploggingId: personnalPlogging.id) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    switch result {
                    case .success(let photoResult):
                        ploggingsUI[ploggingsIndex].mainImage = photoResult
                    case .failure:
                        ploggingsUI[ploggingsIndex].mainImage = icon
                    }
                    displayPersonalPloggings()
                    savePloggingListInCoreData()
                }
            }
        }
    }

    // MARK: - Save Personal Races in CoreData

    private func savePloggingListInCoreData() {
        let ploggingUIListFromCD: [PloggingUI] = getPloggingFromCoreData()
        let ploggingListIdFromCD = ploggingUIListFromCD.map {$0.id}
        let ploggingUIListId = ploggingsUI.map {$0.id}

        ploggingUIListId.forEach { ploggingUIId in
            guard let imageBinary = ploggingsUI.first(where: {$0.id == ploggingUIId})?.mainImage?.jpegData(compressionQuality: 0.8) else { return }

            var ploggingUI = ploggingsUI.first(where: {$0.id == ploggingUIId})
            ploggingUI?.mainImageBinary = imageBinary
            guard let ploggingUIforCD = ploggingUI else { return }

            if ploggingListIdFromCD.contains(ploggingUIId) {
                do {
                    try repository.setEntity(ploggingUI: ploggingUIforCD)
                } catch {
                    return
                }
            } else {
                do {
                    try repository.createEntity(ploggingUI: ploggingUIforCD)
                } catch {
                    return
                }
            }
        }
    }

    // MARK: - Get Personal Races from CoreData

    private func getPloggingFromCoreData() -> [PloggingUI] {
        do {
            let ploggingsCD = try repository.getEntities()
            let ploggingUIList: [PloggingUI] = ploggingsCD.map {PloggingUI(ploggingCD: $0, beginningInt: convertPloggingCDBeginningToBeginningTimestamp(timestampString: $0.beginning), beginningString: convertPloggingCDBeginningToBeginningString(dateString: $0.beginning), isTakingPartUI: isUserTakingPart(ploggingPloggers: $0.ploggers ?? [""]), image: UIImage(data: $0.imageBinary ?? Data()) ?? icon)
            }
            return ploggingUIList.filter({ $0.isTakingPart == true })
        } catch {
            return [PloggingUI]()
        }
    }

    // MARK: - Display Personal Races from CoreData

    private func displayPloggingFromCoreData() {
        ploggingsUI = getPloggingFromCoreData()
        displayPersonalPloggings()
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
            let date =  race.beginningTimestamp
            let nowTimestampInteger = Int(NSDate().timeIntervalSince1970)

            if date > nowTimestampInteger {
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
        performSegue(withIdentifier: SegueIdentifier.fromPersonalToDetails.rawValue, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.fromPersonalToDetails.rawValue {
            let viewController = segue.destination as? PloggingDetailsViewController
            viewController?.ploggingUI = ploggingUI
        } else if segue.identifier == SegueIdentifier.fromPersonalToSignInOrUp.rawValue {
            _ = segue.destination as? SignInOrUpViewController
        }
    }

    // MARK: - Go To Log in

    @IBAction func didTapOnLoginButton() {
        performSegue(withIdentifier: SegueIdentifier.fromPersonalToSignInOrUp.rawValue, sender: nil)
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
