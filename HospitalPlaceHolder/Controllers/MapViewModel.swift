//
//  MapViewModel.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/30/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import RxSwift
import Action

struct MapViewModel {
    let sceneCoordinator: SceneCoordinatorType
    
    func onShowDiseaseDetail() -> Action<DiseaseDetails?, Void> {
        return Action { disease in
            let createDiseaseViewModel = CreateDiseaseViewModel(sceneCoordinator: self.sceneCoordinator, disease: disease)
            return self.sceneCoordinator.transition(to: Scene.createDisease(createDiseaseViewModel), type: .modal)
        }
    }
}
