//
//  ImageRouter.swift
//  Plogging
//
//  Created by adeline honore on 02/12/2023.
//

import Foundation
import FirebaseStorage

protocol GetImageRouterProtocol {
    func getStorageReference() -> StorageReference
}

enum GetImageRouter: GetImageRouterProtocol {
    var storageReference: StorageReference {Storage.storage().reference()}
    case getImage

    func getStorageReference() -> StorageReference {
        switch self {
        case .getImage:
            return storageReference.child("")
        }
    }
}
