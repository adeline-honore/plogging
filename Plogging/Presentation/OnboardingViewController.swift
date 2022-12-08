//
//  OnboardingViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 11/11/2022.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    let stackView = UIStackView()
    let imageView = UIImageView()
    let textLabel = UILabel()
    
    init(imageName: String, textLabelText: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
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
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        textLabel.textAlignment = .center
        
        textLabel.numberOfLines = 0
        textLabel.textColor = Color().appColor
        
        view.backgroundColor = .white
    }
        
    func layout() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),            
            
            textLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: textLabel.trailingAnchor, multiplier: 2),
        ])
    }
}
