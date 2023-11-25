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
            } else {
                print("*****  CLLocationCoordinate2D is not valid ")
            }
        }
        return ploggingAnnotations
    }
    
    private func stringAnnotationDistance(distance: Double) -> String {
        var distanceString = String(distance)
        distanceString = distanceString.replacingOccurrences(of: ".0", with: "")
        distanceString = " " + distanceString + " km"
        return distanceString
    }
    
    private func setAnnotationTitle(ploggingUI: PloggingUI) -> String {
        return " " + ploggingUI.beginningString + "\n" + stringAnnotationDistance(distance: ploggingUI.distance)
    }
}
