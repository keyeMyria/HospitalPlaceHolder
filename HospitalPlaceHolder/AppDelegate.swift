//
//  AppDelegate.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/11/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import UIKit
import GooglePlaces
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var instance = AppDelegate()
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSPlacesClient.provideAPIKey("AIzaSyAnoQYio9VhQAIZrV8BajQRPoEfwalC6qI")
        IQKeyboardManager.sharedManager().enable = true
        
        let sceneCoordinator = SceneCoordinator(window: window!)
        
        if User.currentUser() != nil {
            let searchMapViewModel = MapViewModel(sceneCoordinator: sceneCoordinator)
            let firstScene = Scene.searchMap(searchMapViewModel)
            
            sceneCoordinator.transition(to: firstScene, type: .root)
        } else {
            let loginViewModel = LoginViewModel(sceneCoordinator: sceneCoordinator)
            let firstScene = Scene.login(loginViewModel)
            
            sceneCoordinator.transition(to: firstScene, type: .root)
        }
    
        return true
    }
    
    func changeRootViewControllerWith(vc :UIViewController) {
        if window == nil {
            window = UIApplication.shared.keyWindow
        }
        window?.rootViewController = vc
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

