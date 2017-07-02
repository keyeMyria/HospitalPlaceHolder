//
//  LoginViewModel.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/30/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import RxSwift
import Action

struct LoginViewModel {
    let sceneCoordinator: SceneCoordinatorType
//    let usernameVariable: Variable<String>
//    let passwordVariable: Variable<String>
    let disposeBag = DisposeBag()
    
    func onSignUp() -> CocoaAction {
        return CocoaAction{ _ in
            let signUpViewModel = SignUpViewModel(sceneCoordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.signUp(signUpViewModel), type: .modal)
        }
    }
}
