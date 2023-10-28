//
//  DatabaseUrl.swift
//  Plogging
//
//  Created by HONORE Adeline on 28/10/2023.
//

import Foundation
import FirebaseDatabase

struct DatabaseURL {
    let url: String = "https://plogging-412ed-default-rtdb.europe-west1.firebasedatabase.app/"

    static var ref: DatabaseReference! = Database.database(url: "https://plogging-412ed-default-rtdb.europe-west1.firebasedatabase.app/").reference(fromURL: "https://plogging-412ed-default-rtdb.europe-west1.firebasedatabase.app/")
}
