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

class CreateDiseaseViewController: UIViewController, BindableType {
    @IBOutlet weak var diseaseNameTxtField: UITextField!
    @IBOutlet weak var locationTxtField: UITextField!
    @IBOutlet weak var symptomsTxtView: UITextView!
    @IBOutlet weak var unknownNameSwitch: UISwitch!
    @IBOutlet weak var labsValueTxtView: UITextView!
    @IBOutlet weak var treatmentsTxtView: UITextView!
    @IBOutlet weak var outcomeTxtView: UITextView!
    
    @IBOutlet weak var diseaseNameLabel: UILabel!
    @IBOutlet weak var unknownNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var symptomsLabel: UILabel!
    @IBOutlet weak var treatmentsLabel: UILabel!
    @IBOutlet weak var outComeLabel: UILabel!
    @IBOutlet weak var labsValueLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    var viewModel: CreateDiseaseViewModel!
    var chosenLocation = Variable<CLLocationCoordinate2D>(CLLocationCoordinate2D(latitude: 0, longitude: 0))
    
    var leftBarButton = UIBarButtonItem()
    var rightBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizedStringForUI()
        self.navigationItem.leftBarButtonItem = leftBarButton
        
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
        
    }
    
    func bindViewModel() {
        leftBarButton.rx.action = viewModel.onDismiss()
        
        if self.viewModel.disease == nil {
            let observerValidInput = Observable.combineLatest(diseaseNameTxtField.rx.text, symptomsTxtView.rx.text, locationTxtField.rx.text) { name, desc, address -> Bool in
                return (name?.characters.count)! > 0 && (desc?.characters.count)! > 0 && (address?.characters.count)! > 0
            }
            
            rightBarButton.title = "done".localized()
            rightBarButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onCreateDisease().execute(((self?.diseaseNameTxtField.text)!, (self?.chosenLocation.value.latitude)!, (self?.chosenLocation.value.longitude)!, (self?.symptomsTxtView.text)!, self?.locationTxtField.text, self?.labsValueTxtView.text, self?.treatmentsTxtView.text, self?.outcomeTxtView.text))
                
            })
            .addDisposableTo(rx_disposeBag)
            self.navigationItem.rightBarButtonItem = rightBarButton
            
            observerValidInput
                .subscribeOn(MainScheduler.instance)
                .bind(to: rightBarButton.rx.isEnabled)
                .addDisposableTo(rx_disposeBag)
            
//            locationTxtField.rx.controlEvent(.editingDidBegin)
//                .subscribe { [weak self] _ in
//                    
//                    let autocompleteController = GMSAutocompleteViewController()
//                    autocompleteController.autocompleteFilter?.type = GMSPlacesAutocompleteTypeFilter.geocode
//                    self?.present(autocompleteController, animated: true, completion: nil)
//                    
//                    autocompleteController.rx.didAutoCompleteWithPlace
//                        .subscribeOn(MainScheduler.instance)
//                        .subscribe(onNext: { place in
//                            
//                            self?.locationTxtField.text = place.formattedAddress!
//                            self?.locationTxtField.sendActions(for: .valueChanged) // to notify text field's observer know about the changes
//                            
//                            self?.chosenLocation.value = place.coordinate
//                            autocompleteController.dismiss(animated: true, completion: nil)
//                        })
//                        .addDisposableTo((self?.rx_disposeBag)!)
//                    
//                    autocompleteController.rx.didCancelAutoComplete
//                        .subscribeOn(MainScheduler.instance)
//                        .subscribe(onNext: { _ in
//                            autocompleteController.dismiss(animated: true, completion: nil)
//                        })
//                        .addDisposableTo((self?.rx_disposeBag)!)
//                }
//                .addDisposableTo(rx_disposeBag)
            
            let textSequence = locationTxtField.rx.text
                .throttle(0.5, scheduler: MainScheduler.instance)
            
            viewModel.onGetLocationFromAddress(textSequence: textSequence)
            .do(onNext: { [unowned self] location in
                if location != nil {
                    self.locationTxtField.backgroundColor = UIColor.white
                } else {
                    self.locationTxtField.backgroundColor = UIColor.red
                }
            })
            .subscribe(onNext: { [unowned self] location in
                print("location: \(String(describing: location))")
                if let location = location {
                    self.chosenLocation.value = location
                } else {
                    self.chosenLocation.value = CLLocationCoordinate2D(latitude: 0, longitude: 0)
                }
            })
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
        } else {
            diseaseNameTxtField.text = self.viewModel.disease?.name
            locationTxtField.text = self.viewModel.disease?.address
            symptomsTxtView.text = self.viewModel.disease?.symptoms
            labsValueTxtView.text = self.viewModel.disease?.labsValue
            treatmentsTxtView.text = self.viewModel.disease?.treatments
        }
    }
    
    func localizedStringForUI() {
        self.title = "new".localized()
        leftBarButton.title = "back".localized()
        diseaseNameLabel.text = "disease_name".localized() + ":"
        unknownNameLabel.text = "unknown_name".localized() + ":"
        locationLabel.text = "location".localized() + ":"
        symptomsLabel.text = "symptoms".localized() + ":"
        treatmentsLabel.text = "treatments".localized() + ":"
        outComeLabel.text = "outcome".localized() + ":"
        labsValueLabel.text = "labs".localized() + ":"
    }
}
