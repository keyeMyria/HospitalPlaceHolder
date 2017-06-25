//
//  MapViewExtension.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/25/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import MapKit
import RxSwift
import RxCocoa

class RxMKMapViewDelegate: DelegateProxy, MKMapViewDelegate, DelegateProxyType {
    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let mapView: MKMapView = (object as? MKMapView)!
        return mapView.delegate
    }
    
    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object:
        AnyObject) {
        let mapView: MKMapView = (object as? MKMapView)!
        mapView.delegate = delegate as? MKMapViewDelegate
    }
}

extension Reactive where Base: MKMapView{
    var delegate: DelegateProxy {
        return RxMKMapViewDelegate.proxyForObject(base)
    }
    
    var didSelectAnnotation: Observable<MKAnnotationView>{
        return delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:didSelect:)))
            .map{ parameters in
                return parameters[1] as! MKAnnotationView
        }
    }
}
