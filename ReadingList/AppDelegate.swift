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
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        FirebaseApp.configure()

        let now = Date()
        RealmManager.sharedInstance.deleteExpiredItem(now: now)
        RealmManager.sharedInstance.deleteItem(now: now)
        
        // Clean Architectureのレイヤーを構築
        Application.shared.configure(with: self.window!)
        window?.makeKeyAndVisible()

        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // TODO: vcで検知する方針なので、ここ消したい
//        // UserDefaultに保存されているものを取得して保存
//        if let items = UserDefaultManager.shareInstance.fetchReadingItems() {
//            RealmManager.sharedInstance.addItemToRealm(from: items)
//            // Userdefaultに保存している記事情報を削除
//            UserDefaultManager.shareInstance.deleteReadingItems()
//            NotificationCenter.default.post(name: .updateReadingList, object: nil)
//        }
    }
}
