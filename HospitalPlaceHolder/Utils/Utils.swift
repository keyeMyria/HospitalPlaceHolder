//
//  Utils.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/14/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import UIKit
import RxSwift
import MBProgressHUD

class Utils {
    class var updateAppLanguage: String {
        return "update_app_language"
    }
    
    class var storyboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    @discardableResult
    class func alertViewIn(vc: UIViewController, title: String?, message: String, cancelButton: String, otherButton: [String]? = nil) -> Observable<Int>{
        
        let buttonClickedSubject = PublishSubject<Int>()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: cancelButton, style: UIAlertActionStyle.default, handler: { _ in
            buttonClickedSubject.onNext(0)
        }))
        if otherButton != nil {
            for i in 1...(otherButton?.count)! {
                alert.addAction(UIAlertAction(title: otherButton?[i-1], style: UIAlertActionStyle.default, handler: { _ in
                    buttonClickedSubject.onNext(i)
                }))
            }
        }
        
        vc.present(alert, animated: true, completion: nil)
        
        return buttonClickedSubject.asObserver()
    }
    
    class func showHUDIn(vc: UIViewController){
        MBProgressHUD.showAdded(to: vc.view, animated: true)
    }
    
    class func hideHUDIn(vc: UIViewController){
        MBProgressHUD.hide(for: vc.view, animated: true)
    }
    
    class func setLanguage(lang: String){
        let ud = UserDefaults.standard
        ud.set(lang, forKey: "app_language")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Utils.updateAppLanguage), object: nil)
    }
    
}
