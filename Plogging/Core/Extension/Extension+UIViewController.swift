//
//  Extension+UIViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 09/10/2022.
//

import UIKit

extension UIViewController {
    private func displayAlert(title: String? = nil, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func userAlert(element: AlertType) {
        displayAlert(message: element.message)
    }
        
    func setupKeyboardDismissRecognizer(_ viewController: UIViewController) {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(viewController.dismissKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
