//
//  SetProfileViewController.swift
//  Plogging
//
//  Created by HONORE Adeline on 20/12/2022.
//

import UIKit

class SetProfileViewController: SetConstraintForKeyboardViewController {

    // MARK: - Properties

    private var setProfileView: SetProfileView!

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileView = view as? SetProfileView

        setProfileView.pseudoTextField.becomeFirstResponder()
        setupKeyboardDismissRecognizer(self)
    }
}
