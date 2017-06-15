//
//  CreateDiseaseViewController.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/14/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import UIKit
import RxSwift

class CreateDiseaseViewController: UIViewController{
    @IBOutlet weak var diseaseNameTxtField: UITextField!
    @IBOutlet weak var locationTxtField: UITextField!
    @IBOutlet weak var descriptionTxtView: UITextView!
    
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
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.title = "Done"
        rightBarButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            
            APIManager.instance.createDisease(name: (self?.diseaseNameTxtField.text)!, lat: 20.575180, long: 106.405148, description: (self?.descriptionTxtView.text)!)
            .debug("api")
            .subscribe(onError: { error in
                print(error)
            }, onCompleted: {
                self?.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo((self?.rx_disposeBag)!)
        })
        .addDisposableTo(rx_disposeBag)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}
