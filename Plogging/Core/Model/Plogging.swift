//
//  Plogging.swift
//  Plogging
//
//  Created by HONORE Adeline on 17/10/2022.
//

import Foundation

struct PloggingDatas: Codable {
    let datas: [Plogging]
}

struct Plogging: Codable {
    var id: String
    var admin: String
    var beginning: String
    var place: String
    var latitude: Double
    var longitude: Double
    var ploggers: [String]
    var distance: Double

    init() {
        id = ""
        admin = ""
        beginning = ""
        place = ""
        latitude = 0.0
        longitude = 0.0
        ploggers = [""]
        distance = 10
    }

    func stringDateToDateObject(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"

        guard let date = dateFormatter.date(from: dateString) else { return Date() }

        return date
    }
}
