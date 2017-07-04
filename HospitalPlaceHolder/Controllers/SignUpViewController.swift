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

class SignUpViewController: UIViewController, BindableType  {
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    @IBOutlet weak var codeTxtField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var validUsernameSubject = BehaviorSubject<Bool>(value: false)
    var viewModel: SignUpViewModel!
    
    var leftBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "sign_up".localized()
        usernameTxtField.placeholder = "username".localized()
        passwordTxtField.placeholder = "pass".localized()
        confirmPasswordTxtField.placeholder = "conf_pass".localized()
        codeTxtField.placeholder = "code".localized()
        submitButton.setTitle("submit".localized(), for: .normal)
        
        leftBarButton.title = "back".localized()
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        Observable.combineLatest(validUsernameSubject, passwordTxtField.rx.text, confirmPasswordTxtField.rx.text) {
            $0 && ($1?.characters.count)! > 0 && $1 == $2
        }
        .bind(to: submitButton.rx.isEnabled)
        .addDisposableTo(rx_disposeBag)
        
    }
    
    func bindViewModel() {
        leftBarButton.rx.action = viewModel.onDismiss()
        
        submitButton.rx.tap
        .subscribe(onNext: {[weak self] _ in
            self?.viewModel.onSignUp().execute(((self?.usernameTxtField.text)!, (self?.passwordTxtField.text)!, (self?.codeTxtField.text)!))
        })
        .addDisposableTo(rx_disposeBag)
        
        viewModel.apiErrorSubject
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: {[weak self] apiError in
            switch apiError{
            case .otherError(let error):
                Utils.alertViewIn(vc: self!, title: "error".localized(), message: error.localizedDescription, cancelButton: "ok".localized())
            case .wrongUsernamePassword:
                break
                
            }
        })
        .addDisposableTo(rx_disposeBag)
        
        let usernameSequence = usernameTxtField.rx.text
        .skip(1)
        .filter{ [weak self] text in
            if (text?.characters.count)! <= 2 {
                self?.validUsernameSubject.onNext(false)
                self?.usernameTxtField.backgroundColor = UIColor.white
            }
            return (text?.characters.count)! > 2
        }
        
        viewModel.onCheckExistingUsername(textSequence: usernameSequence)
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
        .addDisposableTo(rx_disposeBag)
    }
}
