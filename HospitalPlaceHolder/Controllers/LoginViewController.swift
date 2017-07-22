//
//  LoginViewController.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/11/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class LoginViewController: UIViewController, BindableType {
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "login".localized()
        phoneTextField.placeholder = "username".localized()
        passwordTextField.placeholder = "pass".localized()
        loginButton.setTitle("login".localized(), for: .normal)
        signUpButton.setTitle("sign_up".localized(), for: .normal)
        facebookButton.setTitle("login_facebook".localized(), for: .normal)
        
        Observable.combineLatest(phoneTextField.rx.text, passwordTextField.rx.text) {
            ($0?.characters.count)! > 0 && ($1?.characters.count)! > 0
        }
        .bind(to: loginButton.rx.isEnabled)
        .addDisposableTo(rx_disposeBag)
    }
    
    func bindViewModel() {
        signUpButton.rx.action = viewModel.onSignUp()
        
        viewModel.loadingVariable.asDriver()
        .drive(onNext: { [weak self] isLoading in
            if isLoading {
                Utils.showHUDIn(vc: self!)
            } else {
                Utils.hideHUDIn(vc: self!)
            }
        })
        .addDisposableTo(rx_disposeBag)
        
        facebookButton.rx.tap
        .subscribe(onNext: { [unowned self] _ in
            FacebookManager.instance.loginByFacebookIn(vc: self)
                .subscribe(onNext: {[unowned self] facebookId in
                    if let facebookId = facebookId {
                        self.viewModel.onLoginByFacebook(facebookId: facebookId)
                    }
                }, onError: { error in
                    Utils.alertViewIn(vc: self, title: "error".localized(), message: error.localizedDescription, cancelButton: "ok".localized())
                })
                .addDisposableTo(self.rx_disposeBag)
        })
        .addDisposableTo(rx_disposeBag)
        
        loginButton.rx.tap
        .map{[unowned self] _ in
            return ((self.phoneTextField.text)!, (self.passwordTextField.text)!)
        }
        .subscribe(onNext: {[unowned self] input in
            self.viewModel.onLogin().execute(input)
        })
        .addDisposableTo(rx_disposeBag)
        
        viewModel.loginErrorSubject
        .subscribe(onNext: {[weak self] error in
            switch error {
                case .wrongUsernamePassword:
                    Utils.alertViewIn(vc: self!, title: "error".localized(), message: "wrong_pass_username".localized(), cancelButton: "ok".localized())
                    
                case .otherError(let error):
                    Utils.alertViewIn(vc: self!, title: "error".localized(), message: error.localizedDescription, cancelButton: "ok".localized())
            }
        })
        .addDisposableTo(rx_disposeBag)
    }
}
