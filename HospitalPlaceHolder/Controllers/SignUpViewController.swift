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
        
        usernameTxtField.rx.text
        .skip(1)
        .filter{ [weak self] text in
            if (text?.characters.count)! <= 2 {
                self?.usernameTxtField.backgroundColor = UIColor.white
            }
            return (text?.characters.count)! > 2
        }
        .subscribe(onNext: { [weak self] text in
            APIManager.instance.isExistingUserWith(username: text)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] existing in
                if existing {
                    self?.usernameTxtField.backgroundColor = UIColor.red
                } else {
                    self?.usernameTxtField.backgroundColor = UIColor.white
                }
            })
            .addDisposableTo((self?.rx_disposeBag)!)
        })
        .addDisposableTo(rx_disposeBag)
    }
}
