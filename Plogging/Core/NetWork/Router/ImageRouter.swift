//
//  ImageRouter.swift
//  Plogging
//
//  Created by adeline honore on 02/12/2023.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

protocol ImageRouterProtocol {
    func getStorageReference() -> StorageReference
    var firestoreDatabase: Firestore { get }
}

enum ImageRouter: ImageRouterProtocol {
    var storageReference: StorageReference {Storage.storage().reference()}
    var firestoreDatabase: Firestore { Firestore.firestore() }
    case getImage
    case uploadImage

    func getStorageReference() -> StorageReference {
        switch self {
        case .getImage, .uploadImage:
            return storageReference.child("")
        }
    }
}
