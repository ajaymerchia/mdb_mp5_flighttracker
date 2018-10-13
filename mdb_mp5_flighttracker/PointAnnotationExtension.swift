//
//  PointAnnotationExtension.swift
//  
//
//  Created by Ajay Raj Merchia on 10/12/18.
//

import Foundation
import MapKit

class MKPointAnnotationWithAirport: MKPointAnnotation {
    var airport: Airport!
    init(airport: Airport) {
        self.airport = airport
    }
}
