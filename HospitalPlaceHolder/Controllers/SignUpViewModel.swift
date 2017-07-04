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
    let disposeBag = DisposeBag()
    let apiErrorSubject = PublishSubject<ApiFailed>()
    
    func onDismiss() -> CocoaAction {
        return CocoaAction{ _ in
            return self.sceneCoordinator.pop()
        }
    }
    
    func onSignUp() -> Action<(String, String, String), Void> {
        return Action{ input in
            let userType = input.2 == "12345" ? 1 : 2
            
            APIManager.instance.registerUser(username: input.0, password: input.1, userType: userType)
                .subscribe(onNext: { user in
                    let user = User(with: user)
                    user.saveCurrentUser()
                    
                    let mapViewModel = MapViewModel(sceneCoordinator: self.sceneCoordinator)
                    self.sceneCoordinator.transition(to: Scene.searchMap(mapViewModel), type: .root)
                }, onError: { error in
                    self.apiErrorSubject.onNext(.otherError(error))
                })
                .addDisposableTo(self.disposeBag)
            
            return Observable.just()
        }
    }
    
    func onCheckExistingUsername(textSequence: Observable<String?>) -> Observable<Bool> {
        return textSequence.flatMapLatest({ text in
            return  APIManager.instance.isExistingUserWith(username: text!)
        })
    }
}
