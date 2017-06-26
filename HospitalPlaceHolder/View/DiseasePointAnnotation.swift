//
//  DiseasePointAnnotation.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/25/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import UIKit
import MapKit

class DiseasePointAnnotation: MKPointAnnotation{
    
    var disease: DiseaseDetails
    
    init(disease: DiseaseDetails) {
        self.disease = disease
        super.init()
        self.title = disease.name
        self.coordinate = CLLocationCoordinate2D(latitude: disease.lat, longitude: disease.long)
    }
}
