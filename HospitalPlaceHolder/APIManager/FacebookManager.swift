//
//  FacebookManager.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/22/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import FacebookCore
import FacebookLogin
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
    
}
