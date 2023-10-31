//
//  PopUpModalViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 31/10/2023.
//

import UIKit

protocol PopUpModalDelegate: AnyObject {
    func didValidateAction()
}

// MARK: - Display Modal Pop up into View Controllers
class PopUpModalViewController: UIViewController {

    weak var delegate: PopUpModalDelegate?

    private func displayAlert(title: String, message: String, viewController: UIViewController) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController.present(alertVC, animated: true, completion: nil)
    }

    func userAlert(element: AlertType, viewController: UIViewController) {
        displayAlert(title: element.title, message: element.message, viewController: viewController)
    }

    private func displayChoiceAlert(element: AlertType, viewController: UIViewController) {
        let alertVC = UIAlertController(title: element.title, message: element.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alertVC.addAction(UIAlertAction(title: "Validate", style: .default, handler: { _ in
            self.choiceValidated(element: element)
        }))
        viewController.present(alertVC, animated: true, completion: nil)
    }

    func userAlertWithChoice(element: AlertType, viewController: UIViewController) {
        displayChoiceAlert(element: element, viewController: viewController)
    }

    func choiceValidated(element: AlertType) {
        if element == AlertType.haveToLogin {
            performSegue(withIdentifier: SegueIdentifier.fromMapToSignInOrUP.identifier, sender: self)
        } else if element == AlertType.wantToParticipate || element == AlertType.wantToNoParticipate {
            delegate?.didValidateAction()
        }
    }
}
