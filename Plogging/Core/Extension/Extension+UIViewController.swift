//
//  Extension+UIViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 09/10/2022.
//

import UIKit
import SystemConfiguration

extension UIViewController {
    private func displayAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func userAlert(element: AlertType) {
        displayAlert(title: element.title, message: element.message)
    }
    
    private func displayChoiceAlert(element: AlertType) {
        let alertVC = UIAlertController(title: element.title, message: element.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//        alertVC.addAction(UIAlertAction(title: "Validate", style: .default, handler: choiceValidated(element: element, completion: () -> Void)))
        present(alertVC, animated: true, completion: nil)
    }
    
    func userAlertWithChoice(element: AlertType) {
        displayChoiceAlert(element: element)
    }
    
    func choiceValidated(element: AlertType, completion: () -> Void) {
        if element == AlertType.haveToLogin {
            performSegue(withIdentifier: SegueIdentifier.fromMapToSignInOrUP.identifier, sender: self)
        }
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
    
    func validateEmail(email: String) -> Bool {
        // Create the regex
        let emailRegEx = #"^[a-z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-z0-9-]+(?:\.[a-z0-9-]+)*$"#
        guard let gRegex = try? NSRegularExpression(pattern: emailRegEx) else {
            return false
        }
        // Create the range
        let range = NSRange(location: 0, length: email.utf16.count)
        // Perform the test
        if gRegex.firstMatch(in: email, options: [], range: range) != nil {
            return true
        }
        return false
    }
}

// MARK: - Check Internet Connection

extension UIViewController {
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}
