//
//  AppDelegate.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/08.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        let now = Date()
        RealmManager.sharedInstance.deleteExpiredItem(now: now)
        RealmManager.sharedInstance.deleteItem(now: now)
        
        configireUI()
        return true
    }
    
    private func configireUI() {
        let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeVC
        let homeModel = HomeModel()
        let homePresenter = HomePresenter(view: homeVC, model: homeModel)
        homeVC.inject(presenter: homePresenter)
        let homeNav = UINavigationController()
        homeNav.viewControllers = [homeVC]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = homeNav
        window?.makeKeyAndVisible()
    }
}
