//
//  APIManager.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/11/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import Foundation
import Apollo
import RxSwift
import RxCocoa
import CoreLocation

let graphQLEndpoint = "https://api.graph.cool/simple/v1/cj3bpd484nnm20185dmf2tqm6"
let apollo = ApolloClient(url: URL(string: graphQLEndpoint)!)

class APIManager {
    static var instance = APIManager()
    
    func createDisease(name: String, lat: Double, long: Double, symptoms: String, address: String? = nil, labsValue: String? = nil, treatments: String? = nil, outcome: String? = nil) -> Observable<String> {
        return Observable.create{ observer in
            let createDiseaseMutation = CreateDiseaseMutation(name: name, lat: lat, long: long, symptoms: symptoms, address: address, labsValue: labsValue, treatments: treatments, outcome: outcome)
            apollo.perform(mutation: createDiseaseMutation) { result, error in
            
                if let error = error {
                    print(error.localizedDescription)
                    observer.onError(error)
                } else {
                    let diseaseID = result?.data?.createDisease?.id
                    observer.onNext(diseaseID!)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    
    func getDiseaseBy(name: String) -> Observable<[DiseaseDetails]> {
        return Observable.create{ observer in
            let allDiseaseQuery = DiseasesByQuery(name: name)
            apollo.fetch(query: allDiseaseQuery) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    observer.onError(error)
                } else {
                    if let diseases = result?.data?.allDiseases {
                        let diseaseArray = diseases.map{ $0.fragments.diseaseDetails }
                        observer.onNext(diseaseArray)
                        observer.onCompleted()
                    } else {
                        observer.onCompleted()
                    }
                }
            }
                
            return Disposables.create()
        }
    }
    
    func loginUserWith(username: String, password: String) -> Observable<UserDetails?> {
        return Observable.create{ observer in
            let loginUser = LoginUserQuery(username: username, password: password)
            apollo.fetch(query: loginUser) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    observer.onError(error)
                } else {
                    if (result?.data?.allUsers.count)! > 0 {
                        observer.onNext(result?.data?.allUsers[0].fragments.userDetails)
                        observer.onCompleted()
                    } else {
                        observer.onNext(nil)
                        observer.onCompleted()
                    }
                }
            }
            
            return Disposables.create()
        }
    }
    
    func loginUserByFacebook(facebookId: String) -> Observable<Bool> {
        return Observable.create{ observer in
            let loginUser = LoginUserByFacebookIdQuery(facebookId: facebookId)
            apollo.fetch(query: loginUser) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    observer.onError(error)
                } else {
                    if (result?.data?.allUsers.count)! > 0 {
                        observer.onNext(true)
                    } else {
                        observer.onNext(false)
                    }
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    
    func isExistingUserWith(username: String!) -> Observable<Bool> {
        return Observable.create{ observer in
            let queryUser = UserByQuery(username: username)
            apollo.fetch(query: queryUser) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    observer.onNext(false)
                } else {
                    if (result?.data?.allUsers.count)! > 0 {
                        observer.onNext(true)
                    } else {
                        observer.onNext(false)
                    }
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func registerUser(username: String, password: String, userType: Int) -> Observable<UserDetails> {
        return Observable.create{ observer in
            let createUser = RegisterUserMutation(username: username, password: password, userType: userType)
            apollo.perform(mutation: createUser, resultHandler: { result, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    if let user = result?.data?.createUser?.fragments.userDetails {
                        observer.onNext(user)
                    }
                    observer.onCompleted()
                }
            })
            
            return Disposables.create()
        }
    }
    
    func getLocationFromAddress(address: String) -> Observable<CLLocationCoordinate2D?> {
        return Observable.create{ observer in
            
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                if let placemarks = placemarks, let location = placemarks.first?.location{
                    observer.onNext(location.coordinate)
                } else {
                    observer.onNext(nil)
                }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
