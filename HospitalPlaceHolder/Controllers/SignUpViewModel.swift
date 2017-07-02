//
//  SignUpViewModel.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/30/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import RxSwift
import Action

struct SignUpViewModel {
    let sceneCoordinator: SceneCoordinatorType
    
    func onDismiss() -> CocoaAction {
        return CocoaAction{ _ in
            return self.sceneCoordinator.pop()
        }
    }
}
