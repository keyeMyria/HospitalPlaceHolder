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
//    let usernameVariable: Variable<String>
//    let passwordVariable: Variable<String>
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
                        
                        let mapViewModel = MapViewModel(sceneCoordinator: self.sceneCoordinator)
                        self.sceneCoordinator.transition(to: Scene.searchMap(mapViewModel), type: .root)
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
}
