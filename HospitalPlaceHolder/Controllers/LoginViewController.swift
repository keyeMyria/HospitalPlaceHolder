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

class LoginViewController: UIViewController {
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login"
        
        Observable.combineLatest(phoneTextField.rx.text, passwordTextField.rx.text) {
            ($0?.characters.count)! > 0 && ($1?.characters.count)! > 0
        }
        .bind(to: loginButton.rx.isEnabled)
        .addDisposableTo(rx_disposeBag)
        
        loginButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            
            APIManager.instance.loginUserWith(username: (self?.phoneTextField.text)!, password: (self?.passwordTextField.text)!)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { user in
                if let user = user {
                    let currUser = User(with: user)
                    currUser.saveCurrentUser()
                    
                    let mapVC = Utils.storyboard.instantiateViewController(withIdentifier: "MapViewController")
                    let navVC = UINavigationController(rootViewController: mapVC)
                    AppDelegate.instance.changeRootViewControllerWith(vc: navVC)
                } else {
                    print("wrong pass or username")
                }
            }, onError: { error in
                print(error)
            })
            .addDisposableTo((self?.rx_disposeBag)!)
            
        })
        .addDisposableTo(rx_disposeBag)
        
        signUpButton.rx.tap
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            let signUpVC = Utils.storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
            let navVC = UINavigationController(rootViewController: signUpVC)
            self?.present(navVC, animated: true, completion: nil)
        })
        .addDisposableTo(rx_disposeBag)
    }
}
