//
//  PersonalPloggingViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 14/11/2022.
//

import UIKit

class PersonalPloggingViewController: UIViewController {

    // MARK: - IBOutlet

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
    private var ploggings: [Plogging] = []

    private var ploggingsUI: [PloggingUI] = []
    private var ploggingsSection: [[PloggingUI]] = [[], []]
    private var ploggingUI: PloggingUI?

    private var dateNowInteger: Date = Date()

    private let icon = UIImage(imageLiteralResourceName: "icon")
    
    private var isTakingPart: Bool = false

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        noPloggingLabel.isHidden = true
        networkErrorLabel.isHidden = true

        isConnectedUser = UserDefaults.standard.string(forKey: UserDefaultsName.emailAddress.rawValue) != nil

        tableView.isHidden = !isConnectedUser
        haveToLoginView.isHidden = isConnectedUser
        haveToLoginTextLabel.isHidden = isConnectedUser
        haveToLoginTextLabel.text = Texts.haveToLoginMessage.value
        haveToLoginButton.isHidden = isConnectedUser
        getPersonalPloggings()
        createDataSection()
        tableView.reloadData()
        
        isTakingPart = ploggingUI?.ploggers?.contains(UserDefaults.standard.string(forKey: UserDefaultsName.emailAddress.rawValue) ?? "") != nil
    }

    // MARK: - Display Personal Races

    private func displayPersonalPloggings() {
        tableView.isHidden = ploggingsUI.isEmpty
        
        if isConnectedUser && !ploggingsUI.isEmpty {
            noPloggingLabel.isHidden = false
            noPloggingLabel.text = Texts.noPlogging.value
            noPloggingLabel.textColor = Color().appColor
        } else {
            noPloggingLabel.isHidden = true
        }
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            ploggingList.forEach { item in
                if self.isTakingPart {
                    self.ploggings.append(item)
                }
            }
            self.savePloggingListInCoreData(ploggingList: self.ploggings)
        }
    }

    private func savePloggingListInCoreData(ploggingList: [Plogging]) {
        displayPloggingFromCoreData()
    }

    private func displayPloggingFromCoreData() {
        do {
            let ploggingsCD = try repository.getEntities()
            ploggingsUI = ploggingsCD.map { PloggingUI(
                ploggingCD: $0,
                beginning: repository.stringDateToDateObject(dateString: $0.beginning ?? ""),
                image: UIImage(data: $0.imageBinary ?? Data()) ?? icon,
                photos: photosCDToPhotosUI(photosCD: getPhotosFromOwner(owner: $0) ?? [PhotoCD]()))
            }
        } catch {
            fatalError()
        }
        displayPersonalPloggings()
    }

    private func getPhotosFromOwner(owner: PloggingCD) -> [PhotoCD]? {
        do {
            return try repository.getPloggingPhoto(owner: owner)
        } catch {
            print("getPhotosFromOwner")
        }
        return nil
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

    // MARK: - View details of plogging

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

    // MARK: - Log in

    @IBAction func didTapOnLoginButton() {
        performSegue(withIdentifier: SegueIdentifier.fromPersonalToSignInOrUp.identifier, sender: nil)
    }

}

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
