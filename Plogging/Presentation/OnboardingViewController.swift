//
//  OnboardingViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 11/11/2022.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    
    let textLabel = UILabel()
    
    init(textLabelText: String) {
        super.init(nibName: nil, bundle: nil)
        textLabel.text = textLabelText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension OnboardingViewController {
    
    func style() {
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        textLabel.textAlignment = .center
        
        textLabel.numberOfLines = 0
        textLabel.textColor = .green
        
        view.backgroundColor = .white
    }
        
    func layout() {
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            textLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: textLabel.trailingAnchor, multiplier: 2),
        ])
    }
}
