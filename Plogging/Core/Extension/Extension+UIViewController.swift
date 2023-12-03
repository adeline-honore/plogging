//
//  Extension+UIViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 09/10/2022.
//

import UIKit
import SystemConfiguration

extension UIViewController {

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

// MARK: - Date Formatter
extension UIViewController {
    func convertDateToIntegerTimestamp(date: Date) -> Int {
        return Int(date.timeIntervalSince1970)
    }
}

// MARK: - Is Taking Part
extension UIViewController {
    func isUserTakingPart(ploggingPloggers: [String], userEmail: String) -> Bool {
        let isParticipate = ploggingPloggers.contains(userEmail)
        return isParticipate
    }

    func convertPloggingCDBeginningToBeginningString(dateString: String?) -> String {
        guard let dateCD = dateString, let dateInteger = Int(dateCD) else {
            return "unable to display correct date"
        }

        let date = NSDate(timeIntervalSince1970: TimeInterval(dateInteger))

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY MMM d, HH:mm"
            let dateUI = dateFormatter.string(from: date as Date)
            return dateUI
    }

    func convertPloggingCDBeginningToBeginningTimestamp(timestampString: String?) -> Int {
        guard timestampString != nil else { return 0 }
        if let timestamp = Int(timestampString!) {
            return timestamp
        }
        return 0
    }
}
