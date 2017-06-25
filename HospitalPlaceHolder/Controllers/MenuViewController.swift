//
//  MenuViewController.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/25/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SDWebImage

class MenuViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var logoutButon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currUser = User.currentUser()
        usernameLabel.text = (currUser?.username)! + " - " + (currUser?.name)!
        userTypeLabel.text = currUser?.userType == 1 ? "Healthcare provider" : ""
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.sd_setImage(with: URL(string: (currUser?.url)!), placeholderImage: UIImage(named: "ic_account_circle"))
        
        languageLabel.text = "languages".localized()
        logoutLabel.text = "logout".localized()
        
        logoutButon.rx.tap
        .subscribe(onNext:{ [weak self] _ in
            Utils.alertViewIn(vc: self!, title: "logout_up".localized(), message: "want_logout".localized(), cancelButton: "cancel".localized(), otherButton: ["ok".localized()])
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { buttonIndex in
                if buttonIndex == 1 {
                    currUser?.deleteUser()
                    let loginVC = Utils.storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    let navVC = UINavigationController(rootViewController: loginVC)
                    AppDelegate.instance.changeRootViewControllerWith(vc: navVC)
                }
            })
            .addDisposableTo((self?.rx_disposeBag)!)
            
        })
        .addDisposableTo(rx_disposeBag)
        
        languageButton.rx.tap
        .subscribe { [weak self] _ in
            if self != nil {
                Utils.alertViewIn(vc: self!, title: "choose_language_up".localized(), message: "choose_language".localized(), cancelButton: "vi".localized(), otherButton: ["en".localized()])
                    .subscribeOn(MainScheduler.instance)
                    .subscribe(onNext: { buttonIndex in
                        if buttonIndex == 0 {
                            Utils.setLanguage(lang: "vi")
                        } else {
                            Utils.setLanguage(lang: "en")
                        }
                    })
                    .addDisposableTo((self?.rx_disposeBag)!)
            }
        }
        .addDisposableTo(rx_disposeBag)
    }
    
    
}
