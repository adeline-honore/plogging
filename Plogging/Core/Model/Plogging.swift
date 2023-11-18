//
//  Plogging.swift
//  Plogging
//
//  Created by HONORE Adeline on 17/10/2022.
//

import Foundation

// MARK: - PloggingDatas
struct PloggingDatas: Codable {
    let datas: [Plogging]
}

// MARK: - Plogging
struct Plogging: Codable {
    var admin: String
    var beginning: Int
    var distance: Int
    var id: String
    var latitude: Double
    var longitude: Double
    var place: String
    var ploggers: [String]

    init() {
        admin = ""
        beginning = 0
        distance = 10
        id = ""
        latitude = 0.0
        longitude = 0.0
        place = ""
        ploggers = [""]
       
    }
}
