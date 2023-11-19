//
//  PloggingLoader.swift
//  Plogging
//
//  Created by HONORE Adeline on 21/10/2022.
//

import CoreLocation

final class PloggingLoader {

    var networkService = NetworkService(network: Network())

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func createAnnotationFromPloggingModels(model: [PloggingUI]) -> [PloggingAnnotation] {

        var ploggingAnnotations: [PloggingAnnotation] = []

        model.forEach {model in
            let annotation = PloggingAnnotation(model.latitude, model.longitude, title: model.beginningString, subtitle: model.id)

            if CLLocationCoordinate2DIsValid(annotation.coordinate) {
                ploggingAnnotations.append(annotation)
            } else {
                print("*****  CLLocationCoordinate2D is not valid ")
            }
        }
        return ploggingAnnotations
    }
}
