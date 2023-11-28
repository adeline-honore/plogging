//
//  PloggingLoader.swift
//  Plogging
//
//  Created by HONORE Adeline on 21/10/2022.
//

import CoreLocation

final class PloggingLoader {
    func createAnnotationFromPloggingModels(model: [PloggingUI]) -> [PloggingAnnotation] {

        var ploggingAnnotations: [PloggingAnnotation] = []

        model.forEach {model in
            let annotation = PloggingAnnotation(model.latitude, model.longitude, title: setAnnotationTitle(ploggingUI: model), subtitle: model.id)

            if CLLocationCoordinate2DIsValid(annotation.coordinate) {
                ploggingAnnotations.append(annotation)
            }
        }
        return ploggingAnnotations
    }

    private func stringAnnotationDistance(distance: Int) -> String {
        var distanceString = String(distance)
        distanceString = " " + distanceString + " km"
        return distanceString
    }

    private func setAnnotationTitle(ploggingUI: PloggingUI) -> String {
        return " " + ploggingUI.beginningString + "\n" + stringAnnotationDistance(distance: ploggingUI.distance)
    }
}
