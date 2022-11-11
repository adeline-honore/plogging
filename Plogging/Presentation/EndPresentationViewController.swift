//
//  EndPresentationViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 11/11/2022.
//

import UIKit

class EndPresentationViewController: UIViewController {
 
    var button = UIButton()
            
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        button = makeButton(withText: Texts.onBoardingTabThree.value)
        layout()
        
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .primaryActionTriggered)
        
        NSLayoutConstraint.activate([
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension EndPresentationViewController {
    
    func layout() {
        view.addSubview(button)
    }
    
    
    func makeButton(withText text: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = .green
        button.layer.cornerRadius = 8
        return button
    }

    @objc func buttonTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        PresentationViewController().passPresentation()
    }
}

