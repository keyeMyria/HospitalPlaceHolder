//
//  MapViewController.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/13/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search map"
        
    }
}
