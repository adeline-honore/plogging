//
//  CallBackResult.swift
//  Plogging
//
//  Created by HONORE Adeline on 31/10/2023.
//

import Foundation

enum FirebaseResult {
    case success
}

enum ErrorType: Error {
    case network
    case coredataError
    case snapshotDoNotExist
}
