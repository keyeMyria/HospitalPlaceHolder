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
    }
}
