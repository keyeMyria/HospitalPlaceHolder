//
//  MapViewController.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/13/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxGesture

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isMenuOpenVariable = Variable<Bool>(false)
    var menuVCWidth: CGFloat = 0;
    let menuVC = Utils.storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "search_map".localized()
        
        if User.currentUser()?.userType == 1 {
            let rightBarButton = UIBarButtonItem()
            rightBarButton.title = "new_case".localized()
            rightBarButton.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    self?.showDiseaseDetailScreenWith()
                })
                .addDisposableTo(rx_disposeBag)
            self.navigationItem.rightBarButtonItem = rightBarButton
            
            isMenuOpenVariable.asObservable()
            .map{!$0}
            .bind(to: rightBarButton.rx.isEnabled)
            .addDisposableTo(rx_disposeBag)
        }
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.title = "Menu".localized()
        leftBarButton.rx.tap
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            self?.isMenuOpenVariable.value = !(self?.isMenuOpenVariable.value)!
            self?.showHideMenu()
        })
        .addDisposableTo(rx_disposeBag)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        searchBar.rx.text
        .throttle(0.5, scheduler: MainScheduler.instance)
        .filter{ ($0?.characters.count)! > 1 }
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] name  in
            
            APIManager.instance.getDiseaseBy(name: name!.lowercased())
            .subscribe(onNext: { diseases in
                self?.mapView.removeAnnotations((self?.mapView.annotations)!)
                diseases.forEach{ [weak self] in
                    let annotation = DiseasePointAnnotation(disease: $0)
                    self?.mapView.addAnnotation(annotation)
                }
            })
            .addDisposableTo((self?.rx_disposeBag)!)
        })
        .addDisposableTo(rx_disposeBag)
        
        mapView.rx.didSelectAnnotation
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] annotationView in
            let annotation = annotationView.annotation as! DiseasePointAnnotation
            self?.showDiseaseDetailScreenWith(disease: annotation.disease)
        })
        .addDisposableTo(rx_disposeBag)
        
        mapView.rx.tapGesture().subscribe { [weak self] gesture in
            if (self?.searchBar.isFirstResponder)! {
                self?.searchBar.resignFirstResponder()
            }
            if (self?.isMenuOpenVariable.value)! {
                self?.isMenuOpenVariable.value = !(self?.isMenuOpenVariable.value)!
                self?.showHideMenu()
            }
        }
        .addDisposableTo(rx_disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        menuVCWidth = self.view.frame.size.width - 50
        
        self.navigationController?.addChildViewController(menuVC)
        menuVC.view.frame = CGRect(x:  menuVCWidth * -1, y: 0, width: menuVCWidth, height: self.view.frame.size.height)
        self.navigationController?.view.addSubview(menuVC.view)
        menuVC.didMove(toParentViewController: self.navigationController)
    }
    
    func showHideMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            if self.menuVC.view.frame.origin.x < 0 {
                self.menuVC.view.frame.origin = CGPoint(x: 0, y: self.menuVC.view.frame.origin.y)
            } else {
                self.menuVC.view.frame.origin = CGPoint(x: self.menuVCWidth * -1, y: self.menuVC.view.frame.origin.y)
            }
        })
    }
    
    func showDiseaseDetailScreenWith(disease: DiseaseDetails? = nil) {
        let createDiseaseVC = Utils.storyboard.instantiateViewController(withIdentifier: "CreateDiseaseViewController") as! CreateDiseaseViewController
        createDiseaseVC.disease = disease
        let navVC = UINavigationController(rootViewController: createDiseaseVC)
        self.present(navVC, animated: true, completion: nil)
    }
}
