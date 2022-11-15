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
    
    func returnStringFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func setDateStringToInteger(dateString: String) -> Int{
        let result = dateString.filter("0123456789".contains)
        
        guard let integer = Int(result) else {
            return 0
        }
        
        return integer
    }
}
