//
//  LoginViewModel.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/30/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import RxSwift
import Action

enum ApiFailed {
    case wrongUsernamePassword
    case otherError(Error)
}

struct LoginViewModel {
    let sceneCoordinator: SceneCoordinatorType
    let disposeBag = DisposeBag()
    let loadingVariable = Variable<Bool>(false)
    let loginErrorSubject = PublishSubject<ApiFailed>()
    
    func onSignUp() -> CocoaAction {
        return CocoaAction{ _ in
            let signUpViewModel = SignUpViewModel(sceneCoordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.signUp(signUpViewModel), type: .modal)
        }
    }
    
    func onLogin() -> Action<(String, String), Void> {
        return Action { input in
            self.loadingVariable.value = true
            APIManager.instance.loginUserWith(username: input.0, password: input.1)
                .subscribe(onNext: { user in
                    self.loadingVariable.value = false
                    if let user = user {
                        let currUser = User(with: user)
                        currUser.saveCurrentUser()
                        
                        self.showMainScreen()
                    } else {
                        self.loginErrorSubject.onNext(.wrongUsernamePassword)
                    }
                }, onError: { error in
                    self.loadingVariable.value = false
                    self.loginErrorSubject.onNext(.otherError(error))
                })
                .addDisposableTo(self.disposeBag)
            
            return Observable.just()
        }
    }
    
    func onLoginByFacebook(facebookId: String) {
        loadingVariable.value = true
        APIManager.instance.loginUserByFacebook(facebookId: facebookId)
            .subscribe(onNext: {user in
                if let user = user {
                    self.loadingVariable.value = false
                    
                    let currUser = User(with: user)
                    currUser.saveCurrentUser()
                    
                    self.showMainScreen()
                } else {
                    self.getCurrentFBUserInfoAndRegister()
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func getCurrentFBUserInfoAndRegister() {
        FacebookManager.instance.getCurrentFBUserInfo()
            .subscribe(onNext: { info in
                if let info = info {
                    let name = info["name"] as! String
                    let facebookId = info["facebookId"] as! String
                    let url = info["url"] as? String
                    self.registerUserWithFacebook(username: "fbuser-" + name, name: name, facebookId: facebookId, url: url)
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func registerUserWithFacebook(username: String, name: String, facebookId: String, url: String?) {
        APIManager.instance.registerUserByFacebook(username: username, name: name, facebookId: facebookId, url: url)
            .subscribe(onNext: { user in
                self.loadingVariable.value = false
                
                let currUser = User(with: user)
                currUser.saveCurrentUser()
                
                self.showMainScreen()
            })
            .addDisposableTo(disposeBag)
    }
    
    func showMainScreen() {
        let mapViewModel = MapViewModel(sceneCoordinator: self.sceneCoordinator)
        self.sceneCoordinator.transition(to: Scene.searchMap(mapViewModel), type: .root)
    }
}
