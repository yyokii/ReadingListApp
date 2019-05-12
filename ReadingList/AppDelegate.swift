//
//  AppDelegate.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/08.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let listVC = UIStoryboard(name: "List", bundle: nil).instantiateInitialViewController() as! ListVC
//        let model = ListModel()
//        let presenter = ListPresenter(view: listVC, model: model)
//        listVC.inject(presenter: presenter)
//
//        let navVC = UINavigationController()
//        navVC.viewControllers = [listVC]
        
        let ArticleListVC = UIStoryboard(name: "ArticleList", bundle: nil).instantiateViewController(withIdentifier: "ArticleList") as! ArticleListVC
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ArticleListVC
        window?.makeKeyAndVisible()
        
        return true
    }
}

