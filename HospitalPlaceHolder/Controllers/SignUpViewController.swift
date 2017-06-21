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
    
    var validUsernameSubject = BehaviorSubject<Bool>(value: false)
    
    
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
                self?.validUsernameSubject.onNext(false)
                self?.usernameTxtField.backgroundColor = UIColor.white
            }
            return (text?.characters.count)! > 2
        }
        .subscribe(onNext: { [weak self] text in
            APIManager.instance.isExistingUserWith(username: text)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] existing in
                if existing {
                    self?.validUsernameSubject.onNext(false)
                    self?.usernameTxtField.backgroundColor = UIColor.red
                } else {
                    self?.validUsernameSubject.onNext(true)
                    self?.usernameTxtField.backgroundColor = UIColor.white
                }
            })
            .addDisposableTo((self?.rx_disposeBag)!)
        })
        .addDisposableTo(rx_disposeBag)
        
        Observable.combineLatest(validUsernameSubject, passwordTxtField.rx.text, confirmPasswordTxtField.rx.text) {
            $0 && ($1?.characters.count)! > 0 && $1 == $2
        }
        .bind(to: submitButton.rx.isEnabled)
        .addDisposableTo(rx_disposeBag)
        
        submitButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            let userType = (self?.codeTxtField.text)! == "12345" ? 1 : 2
            APIManager.instance.registerUser(username: (self?.usernameTxtField.text)!, password: (self?.passwordTxtField.text)!, userType: userType)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { user in
                
            }, onError: { error in
                print(error)
            })
            .addDisposableTo((self?.rx_disposeBag)!)
        })
        .addDisposableTo(rx_disposeBag)
    }
}
