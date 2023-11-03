//
//  PloggingLoader.swift
//  Plogging
//
//  Created by HONORE Adeline on 21/10/2022.
//

import CoreLocation

final class PloggingLoader {

    let ploggingService: PloggingService

    init(ploggingService: PloggingService) {
        self.ploggingService = ploggingService
    }

    func createAnnotationFromPloggingModels(model: [Plogging]) -> [PloggingAnnotation] {

        var ploggingAnnotations: [PloggingAnnotation] = []

        model.forEach {model in
            let annotation = PloggingAnnotation(model.latitude, model.longitude, title: model.place, subtitle: model.beginning)

            if CLLocationCoordinate2DIsValid(annotation.coordinate) {
                ploggingAnnotations.append(annotation)
            } else {
                print("*****  CLLocationCoordinate2D is not valid ")
            }
        }
        return ploggingAnnotations
    }
}
