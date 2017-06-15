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
import NSObject_Rx

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search map"
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.title = "Add"
        rightBarButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
                let createDiseaseVC = Utils.storyboard.instantiateViewController(withIdentifier: "CreateDiseaseViewController") as! CreateDiseaseViewController
                let navVC = UINavigationController(rootViewController: createDiseaseVC)
                self?.present(navVC, animated: true, completion: nil)
        })
        .addDisposableTo(rx_disposeBag)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        searchBar.rx.text
        .throttle(0.5, scheduler: MainScheduler.instance)
        .filter{ ($0?.characters.count)! > 1 }
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] name  in
            
            APIManager.instance.getDiseaseBy(name: name!.lowercased())
            .subscribe(onNext: { diseases in
                self?.mapView.removeAnnotations((self?.mapView.annotations)!)
                diseases.forEach{ [weak self] in
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.long)
                    annotation.title = $0.name
                    self?.mapView.addAnnotation(annotation)
                }
            })
            .addDisposableTo((self?.rx_disposeBag)!)
        })
        .addDisposableTo(rx_disposeBag)
    }
}
