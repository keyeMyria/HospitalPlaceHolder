//
//  SignUpViewController.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/19/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    @IBOutlet weak var codeTxtField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sign Up"
        
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
