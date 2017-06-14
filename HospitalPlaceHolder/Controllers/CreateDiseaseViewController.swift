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
        .flatMap{ [weak self] _ in
            APIManager.instance.createD(name: (self?.diseaseNameTxtField.text)!, lat: 12.238791, long: 109.196749, description: (self?.descriptionTxtView.text)!)
        }
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { id in
            print(id)
        }, onError: { error in
            print(error)
        }, onCompleted: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        })
        .addDisposableTo(rx_disposeBag)
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}
