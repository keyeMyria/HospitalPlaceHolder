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
        
        Observable.combineLatest(phoneTextField.rx.text, passwordTextField.rx.text) {
            ($0?.characters.count)! > 0 && ($1?.characters.count)! > 0
        }
        .bind(to: loginButton.rx.isEnabled)
        .addDisposableTo(rx_disposeBag)
        
        loginButton.setTitle("login".localized(), for: .normal)
        
        loginButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            
            Utils.showHUDIn(vc: self!)
            APIManager.instance.loginUserWith(username: (self?.phoneTextField.text)!, password: (self?.passwordTextField.text)!)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { user in
                Utils.hideHUDIn(vc: self!)
                if let user = user {
                    let currUser = User(with: user)
                    currUser.saveCurrentUser()
                    
                    let mapVC = Utils.storyboard.instantiateViewController(withIdentifier: "MapViewController")
                    let navVC = UINavigationController(rootViewController: mapVC)
                    AppDelegate.instance.changeRootViewControllerWith(vc: navVC)
                } else {
                    _ = Utils.alertViewIn(vc: self!, title: "error".localized(), message: "wrong_pass_username".localized(), cancelButton: "ok".localized())
                }
            }, onError: {[weak self] error in
                Utils.hideHUDIn(vc: self!)
                _ = Utils.alertViewIn(vc: self!, title: "error".localized(), message: error.localizedDescription, cancelButton: "ok".localized())
            })
            .addDisposableTo((self?.rx_disposeBag)!)
            
        })
        .addDisposableTo(rx_disposeBag)
        
        signUpButton.setTitle("sign_up".localized(), for: .normal)
        
        signUpButton.rx.tap
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            let signUpVC = Utils.storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
            let navVC = UINavigationController(rootViewController: signUpVC)
            self?.present(navVC, animated: true, completion: nil)
        })
        .addDisposableTo(rx_disposeBag)
        
        facebookButton.setTitle("login_facebook".localized(), for: .normal)
        
        facebookButton.rx.tap
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            FacebookManager.instance.loginByFacebookIn(vc: self!)
            .subscribe(onNext: { userId in
                if let userId = userId {
                    print(userId)
                }
            }, onError: { error in
                _ = Utils.alertViewIn(vc: self!, title: "error".localized(), message: error.localizedDescription, cancelButton: "ok".localized())
            })
            .addDisposableTo((self?.rx_disposeBag)!)
        })
        .addDisposableTo(rx_disposeBag)
    }
    
    func bindViewModel() {
        
    }
}
