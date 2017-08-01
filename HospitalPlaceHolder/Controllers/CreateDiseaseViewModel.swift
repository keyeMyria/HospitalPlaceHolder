//
//  CreateDiseaseViewModel.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/30/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import RxSwift
import Action
import CoreLocation

struct CreateDiseaseViewModel {
    let sceneCoordinator: SceneCoordinatorType
    let disease: DiseaseDetails?
    let disposeBag = DisposeBag()
    let createDiseaseErrorSubject = PublishSubject<ApiFailed>()
    
    func onDismiss() -> CocoaAction {
        return CocoaAction{ _ in
            return self.sceneCoordinator.pop()
        }
    }
    
    func onCreateDisease() -> Action<(String, Double, Double, String, String?, String?, String?, String?),Void> {
        return Action{ input in
            APIManager.instance.createDisease(name: input.0, lat: input.1, long: input.2, symptoms: input.3, address: input.4, labsValue: input.5, treatments: input.6, outcome: input.7)
                .subscribe(onError: { error in
                    self.createDiseaseErrorSubject.onNext(.otherError(error))
                }, onCompleted: {
                    self.onDismiss().execute()
                })
                .addDisposableTo(self.disposeBag)
            
            return Observable.just()
        }
    }
    
    func onGetLocationFromAddress(textSequence: Observable<String?>) -> Observable<CLLocationCoordinate2D?> {
        return textSequence.flatMapLatest({ textString in
            return APIManager.instance.getLocationFromAddress(address: textString!)
        })
        
    }
}
