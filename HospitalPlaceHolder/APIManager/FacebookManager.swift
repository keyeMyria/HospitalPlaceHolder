//
//  FacebookManager.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/22/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import FacebookCore
import FacebookLogin

import FBSDKCoreKit
import FBSDKLoginKit

import RxSwift

class FacebookManager {
    
    static var instance = FacebookManager()
    
    
    func loginByFacebookIn(vc: UIViewController) -> Observable<String?> {
        return Observable.create { observer in
            
            let loginManager = LoginManager()
            loginManager.logIn([PublishPermission.publishActions], viewController: vc, completion: { loginResult in
                switch loginResult {
                case .failed(let error):
                    observer.onError(error)
                case .cancelled:
                    observer.onNext(nil)
                case .success( _, _, let accessToken):
                    observer.onNext(accessToken.userId)
                }
                observer.onCompleted()
            })
            
            return Disposables.create()
        }
    }
    
    func getCurrentFBUserInfo() -> Observable<[String: Any]?> {
        
        
        return Observable.create{ observer in
            if(FBSDKAccessToken.current() != nil) {
                let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
                let connection = FBSDKGraphRequestConnection()
                connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                    if result != nil {
                        let data = result as! [String : AnyObject]
                        
                        //                self.label.text = data["name"] as? String
                        
                        let FBid = data["id"] as! String
                        let url = "https://graph.facebook.com/\(FBid)/picture?type=large&return_ssl_resources=1"
                        
                        let dict = ["name":data["name"] as! String, "url":url, "facebookId":FBid] as [String: Any]
                        
                        observer.onNext(dict)
                    } else {
                        observer.onNext(nil)
                    }
                    
                    observer.onCompleted()
                })
                connection.start()
            } else {
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
