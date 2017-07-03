//
//  MenuViewModel.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/30/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import Action
import RxSwift

struct MenuViewModel {
    let sceneCoordinator: SceneCoordinatorType
    
    func onLogOut() -> CocoaAction {
        return CocoaAction{
            User.currentUser()?.deleteUser()
            let loginViewModel = LoginViewModel(sceneCoordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.login(loginViewModel), type: .root)
        }
    }
}
