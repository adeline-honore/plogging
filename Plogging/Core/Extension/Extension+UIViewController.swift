//
//  Extension+UIViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 09/10/2022.
//

import UIKit
import SystemConfiguration

extension UIViewController {

//    @objc func keyboardNotification(notification: NSNotification) {
//        guard let userInfo = notification.userInfo else { return }
//
//        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
//        let endFrameY = endFrame?.origin.y ?? 0
//        let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
//        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
//        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
//        let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
//
//        if endFrameY >= UIScreen.main.bounds.size.height {
//            self.keyboardHeightLayoutConstraint?.constant = 16.0
//        } else {
//            self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 16.0
//        }
//
//        UIView.animate(
//            withDuration: duration,
//            delay: TimeInterval(0),
//            options: animationCurve,
//            animations: { self.view.layoutIfNeeded() },
//            completion: nil)
//    }

    func setupKeyboardDismissRecognizer(_ viewController: UIViewController) {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.keyboardNotification(notification:)),
//                                               name: UIResponder.keyboardWillChangeFrameNotification,
//                                               object: nil)
//
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
