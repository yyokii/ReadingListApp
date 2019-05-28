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
        
        // FIXME: いらないのでは？
        // configureVC()
        
        // おすすめ記事一覧
        let articleListVC = UIStoryboard(name: "ArticleList", bundle: nil).instantiateViewController(withIdentifier: "ArticleList") as! ArticleListVC
        let navFirst = UINavigationController()
        navFirst.viewControllers = [articleListVC]
        
        // リーディングリスト一覧
        let listVC = UIStoryboard(name: "List", bundle: nil).instantiateInitialViewController() as! ListVC
        let model = ListModel()
        let presenter = ListPresenter(view: listVC, model: model)
        listVC.inject(presenter: presenter)
        let navSecond = UINavigationController()
        navSecond.viewControllers = [listVC]
        
        // メニュー
        let aboutAppVC = UIStoryboard(name: "AboutApp", bundle: nil).instantiateInitialViewController() as! AboutAppVC
        let navThird = UINavigationController()
        navThird.navigationBar.prefersLargeTitles = true
        navThird.navigationItem.largeTitleDisplayMode = .always
        navThird.viewControllers = [aboutAppVC]
        
        let tab = UITabBarController()
        tab.viewControllers = [navFirst, navSecond, navThird]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tab
        window?.makeKeyAndVisible()
        return true
    }
    
    private func configureVC() {
        
        let articleListVC = UIStoryboard(name: "ArticleList", bundle: nil).instantiateViewController(withIdentifier: "ArticleList") as! ArticleListVC
        let navFirst = UINavigationController()
        navFirst.viewControllers = [articleListVC]
        
        
        let listVC = UIStoryboard(name: "List", bundle: nil).instantiateInitialViewController() as! ListVC
        let model = ListModel()
        let presenter = ListPresenter(view: listVC, model: model)
        listVC.inject(presenter: presenter)
        let navSecond = UINavigationController()
        navSecond.viewControllers = [listVC]
        
        // タブの作成
        let tabBar = UITabBarController()
        tabBar.viewControllers = [navFirst, navSecond]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }
}

