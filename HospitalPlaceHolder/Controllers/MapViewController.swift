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

class MapViewController: UIViewController, BindableType  {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: MapViewModel!
    
    var isMenuOpenVariable = Variable<Bool>(false)
    var menuVCWidth: CGFloat = 0;
    let menuVC = Utils.storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
    
    let rightBarButton = UIBarButtonItem()
    let leftBarButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextForUI()
        
        if User.currentUser()?.userType == 1 {
            self.navigationItem.rightBarButtonItem = rightBarButton
            
            isMenuOpenVariable.asObservable()
            .map{!$0}
            .bind(to: rightBarButton.rx.isEnabled)
            .addDisposableTo(rx_disposeBag)
        }
        
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
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] name  in
            if name?.characters.count == 0 {
                self?.mapView.removeAnnotations((self?.mapView.annotations)!)
            } else {
                APIManager.instance.getDiseaseBy(name: name!.lowercased())
                    .subscribe(onNext: { diseases in
                        self?.mapView.removeAnnotations((self?.mapView.annotations)!)
                        diseases.forEach{ [weak self] in
                            let annotation = DiseasePointAnnotation(disease: $0)
                            self?.mapView.addAnnotation(annotation)
                        }
                    })
                    .addDisposableTo((self?.rx_disposeBag)!)
            }            
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
        
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: Utils.updateAppLanguage))
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] _ in
            self?.setTextForUI()
        })
        .addDisposableTo(rx_disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if menuVCWidth == 0 {
            menuVCWidth = self.view.frame.size.width - 50
            
            menuVC.viewModel = MenuViewModel(sceneCoordinator: viewModel.sceneCoordinator)
            
            self.navigationController?.addChildViewController(menuVC)
            menuVC.view.frame = CGRect(x:  menuVCWidth * -1, y: 0, width: menuVCWidth, height: self.view.frame.size.height)
            self.navigationController?.view.addSubview(menuVC.view)
            menuVC.didMove(toParentViewController: self.navigationController)
        }
    }
    
    func bindViewModel() {
        mapView.rx.didSelectAnnotation
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] annotationView in
                let annotation = annotationView.annotation as! DiseasePointAnnotation
                self?.viewModel.onShowDiseaseDetail().execute(annotation.disease)
            })
            .addDisposableTo(rx_disposeBag)
        
        rightBarButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.onShowDiseaseDetail().execute(nil)
            })
            .addDisposableTo(rx_disposeBag)
    }
    
    func setTextForUI() {
        self.title = "search_map".localized()
        rightBarButton.title = "new_case".localized()
        leftBarButton.title = "Menu".localized()
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
}
