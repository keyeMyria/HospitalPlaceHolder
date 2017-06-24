//
//  CreateDiseaseViewController.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/14/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import GooglePlaces
import RxGesture

class CreateDiseaseViewController: UIViewController{
    @IBOutlet weak var diseaseNameTxtField: UITextField!
    @IBOutlet weak var locationTxtField: UITextField!
    @IBOutlet weak var symptomsTxtView: UITextView!
    @IBOutlet weak var unknownNameSwitch: UISwitch!
    @IBOutlet weak var labsValueTxtView: UITextView!
    @IBOutlet weak var treatmentsTxtView: UITextView!
    @IBOutlet weak var outcomeTxtView: UITextView!
    
    
    @IBOutlet weak var contentView: UIView!
    
    var chosenLocation = Variable<CLLocationCoordinate2D>(CLLocationCoordinate2D(latitude: 0, longitude: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "new".localized()
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.title = "back".localized()
        leftBarButton.rx.tap
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        })
        .addDisposableTo(rx_disposeBag)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let observerValidInput = Observable.combineLatest(diseaseNameTxtField.rx.text, symptomsTxtView.rx.text, locationTxtField.rx.text) { name, desc, address -> Bool in
            return (name?.characters.count)! > 0 && (desc?.characters.count)! > 0 && (address?.characters.count)! > 0
        }
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.title = "done".localized()
        rightBarButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            
            APIManager.instance.createDisease(name: (self?.diseaseNameTxtField.text)!, lat: (self?.chosenLocation.value.latitude)!, long: (self?.chosenLocation.value.longitude)!, symptoms: (self?.symptomsTxtView.text)!, address: self?.locationTxtField.text, labsValue: self?.labsValueTxtView.text, treatments: self?.treatmentsTxtView.text, outcome: self?.outcomeTxtView.text)
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
        
        contentView.rx.tapGesture().subscribe { [weak self] _ in
            if (self?.diseaseNameTxtField.isFirstResponder)! {
                self?.diseaseNameTxtField.resignFirstResponder()
            } else if (self?.symptomsTxtView.isFirstResponder)! {
                self?.symptomsTxtView.resignFirstResponder()
            } else if (self?.labsValueTxtView.isFirstResponder)! {
                self?.labsValueTxtView.resignFirstResponder()
            } else if (self?.treatmentsTxtView.isFirstResponder)! {
                self?.treatmentsTxtView.resignFirstResponder()
            } else if (self?.outcomeTxtView.isFirstResponder)! {
                self?.outcomeTxtView.resignFirstResponder()
            }
        }
        .addDisposableTo(rx_disposeBag)
        
        unknownNameSwitch.rx.isOn
        .map{ [weak self] isOn in
            if isOn {
                self?.diseaseNameTxtField.text = "unknown".localized()
            } else {
                self?.diseaseNameTxtField.text = ""
            }
            self?.locationTxtField.sendActions(for: .valueChanged)
            return !isOn
        }
        .bind(to: diseaseNameTxtField.rx.isUserInteractionEnabled)
        .addDisposableTo(rx_disposeBag)
    }
}
