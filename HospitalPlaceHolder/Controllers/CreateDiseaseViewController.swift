//
//  CreateDiseaseViewController.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/14/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import UIKit
import RxSwift
import GooglePlaces

class CreateDiseaseViewController: UIViewController{
    @IBOutlet weak var diseaseNameTxtField: UITextField!
    @IBOutlet weak var locationTxtField: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    
    var chosenLocation = Variable<CLLocationCoordinate2D>(CLLocationCoordinate2D(latitude: 0, longitude: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "New"
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.title = "Back"
        leftBarButton.rx.tap
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        })
        .addDisposableTo(rx_disposeBag)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let observerValidInput = Observable.combineLatest(diseaseNameTxtField.rx.text, descriptionTxtView.rx.text, locationTxtField.rx.text) { name, desc, address -> Bool in
            return (name?.characters.count)! > 0 && (desc?.characters.count)! > 0 && (address?.characters.count)! > 0
        }
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.title = "Done"
        rightBarButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            
            APIManager.instance.createDisease(name: (self?.diseaseNameTxtField.text)!, lat: (self?.chosenLocation.value.latitude)!, long: (self?.chosenLocation.value.longitude)!, description: (self?.descriptionTxtView.text)!)
            .subscribe(onError: { error in
                print(error)
            }, onCompleted: {
                self?.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo((self?.rx_disposeBag)!)
        })
        .addDisposableTo(rx_disposeBag)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        observerValidInput
        .subscribeOn(MainScheduler.instance)
        .bind(to: rightBarButton.rx.isEnabled)
        .addDisposableTo(rx_disposeBag)
        
        locationTxtField.rx.controlEvent(.editingDidBegin)
        .subscribe { [weak self] _ in
            
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.autocompleteFilter?.type = GMSPlacesAutocompleteTypeFilter.geocode
            self?.present(autocompleteController, animated: true, completion: nil)
            
            autocompleteController.rx.didAutoCompleteWithPlace
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { place in
                
                self?.locationTxtField.text = place.formattedAddress!
                self?.locationTxtField.sendActions(for: .valueChanged) // to notify text field's observer know about the changes
                
                self?.chosenLocation.value = place.coordinate
                autocompleteController.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo((self?.rx_disposeBag)!)
            
            autocompleteController.rx.didCancelAutoComplete
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                autocompleteController.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo((self?.rx_disposeBag)!)
        }
        .addDisposableTo(rx_disposeBag)
    }
}
