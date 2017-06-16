//
//  GMSPlaceExtension.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/16/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import GooglePlaces
import RxSwift
import RxCocoa

class RxGMSAutocompleteViewControllerDelegateProxy: DelegateProxy, GMSAutocompleteViewControllerDelegate, DelegateProxyType {
    
    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let autocompleteViewController: GMSAutocompleteViewController = (object as? GMSAutocompleteViewController)!
        return autocompleteViewController.delegate
    }
    
    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object:
        AnyObject) {
        let autocompleteViewController: GMSAutocompleteViewController = (object as? GMSAutocompleteViewController)!
        autocompleteViewController.delegate = delegate as? GMSAutocompleteViewControllerDelegate
    }
    
    let placeSubject = PublishSubject<GMSPlace>()
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        placeSubject.onNext(place)
        self._forwardToDelegate?.viewController(viewController, didAutocompleteWith: place)
    }
    
    let errorSubject = PublishSubject<Error>()
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        errorSubject.onNext(error)
        self._forwardToDelegate?.viewController(viewController, didFailAutocompleteWithError: error)
    }
    
    let cancelSubject = PublishSubject<Void>()
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        cancelSubject.onNext()
        self._forwardToDelegate?.wasCancelled(viewController)
    }
    
    deinit {
        placeSubject.onCompleted()
        errorSubject.onCompleted()
        cancelSubject.onCompleted()
    }
}

extension Reactive where Base: GMSAutocompleteViewController {
    var delegate: DelegateProxy {
        return RxGMSAutocompleteViewControllerDelegateProxy.proxyForObject(base)
    }
    
    var didAutoCompleteWithPlace: Observable<GMSPlace>{
        return (delegate as! RxGMSAutocompleteViewControllerDelegateProxy).placeSubject
    }
    
    var didFaildAutoCompleteWithError: Observable<Error>{
        return (delegate as! RxGMSAutocompleteViewControllerDelegateProxy).errorSubject
    }
    
    var didCancelAutoComplete: Observable<Void>{
        return (delegate as! RxGMSAutocompleteViewControllerDelegateProxy).cancelSubject
    }
}
