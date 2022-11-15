//
//  Extension+FloatingPoint.swift
//  Plogging
//
//  Created by HONORE Adeline on 15/11/2022.
//

import Foundation

extension FloatingPoint where Self: CVarArg {
    func fixedFraction(digits: Int) -> String {
        .init(format: "%.*f", digits, self)
    }
}
