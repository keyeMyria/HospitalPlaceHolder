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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "sign_up".localized()
        usernameTxtField.placeholder = "username".localized()
        passwordTxtField.placeholder = "pass".localized()
        confirmPasswordTxtField.placeholder = "conf_pass".localized()
        codeTxtField.placeholder = "code".localized()
        submitButton.setTitle("submit".localized(), for: .normal)
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.title = "back".localized()
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
                let user = User(with: user)
                user.saveCurrentUser()
                
                let mapVC = Utils.storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
                let navVC = UINavigationController(rootViewController: mapVC)
                AppDelegate.instance.changeRootViewControllerWith(vc: navVC)
                
            }, onError: { error in
                print(error)
            })
            .addDisposableTo((self?.rx_disposeBag)!)
        })
        .addDisposableTo(rx_disposeBag)
    }
    
    func bindViewModel() {
        
    }
}
