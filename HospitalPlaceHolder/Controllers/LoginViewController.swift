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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login"
        
        loginButton.rx.tap
        .debug()
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            
            let mapVC = self?.storyboard?.instantiateViewController(withIdentifier: "MapViewController")
            self?.navigationController?.pushViewController(mapVC!, animated: true)
            
        })
        .addDisposableTo(rx_disposeBag)
    }
    
    func storyBoard() -> UIStoryboard {
        return UIStoryboard(name: "main", bundle: nil)
    }
}
