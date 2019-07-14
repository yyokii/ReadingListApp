//
//  AboutAppVC.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/03/24.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import StoreKit
import UserNotifications

class AboutAppVC: UITableViewController {
    let cellTitles = [
        ["「Yomu」の使い方"],
        ["最近削除したもの", "通知設定"],
        ["いいねする", "お問い合わせ", "開発した人"],
    ]
    
    let current = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "このアプリについて"
        confirureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    func confirureTableView() {
        tableView.register(UINib(nibName: "AboutAppTableViewCell", bundle: nil), forCellReuseIdentifier: "AboutAppTableViewCell")
    }
    
    // FIXME:
    private func setNotificationSetting() {
        current.getNotificationSettings(completionHandler: { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                print("authorized")
            case .denied:
                print("denied")
            case .notDetermined:
                print("not determined, ask user for permission now")
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutAppTableViewCell", for: indexPath) as! AboutAppTableViewCell
        let title = cellTitles[indexPath.section][indexPath.row]
        cell.titleLabel.text = title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                print("test")
            default:
                print("警告：未設定のセルをタップ")
            }
        case 1:
            switch indexPath.row {
            case 0:
                let deleteListVC = DeletedListVC.deleteVCInit()
                navigationController?.pushViewController(deleteListVC, animated: true)
            case 1:
                print("test")
            default:
                print("警告：未設定のセルをタップ")
            }
        case 2:
            switch indexPath.row {
            case 0:
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                } else {
                    //                    MDCAlert.showAlert(vc: self, title: "😥", message: "申し訳ございません。現在のOSバージョンではご利用になれません。", isEnableOutsideScreenTouch: true, positiveAction: {})
                }
            case 1:
                print("test")
            case 2:
                let url = URL(string: "https://twitter.com/enyyokii")!
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            default:
                print("警告：未設定のセルをタップ")
            }
        default:
            print("警告：未設定のセルをタップ")
        }
        
        //        switch indexPath.row {
        //        case 0:
        //            let howToVC = UIStoryboard(name: "HowTo", bundle: nil).instantiateInitialViewController() as! HowToViewController
        //            howToVC.presentationCase = .closeButton
        //            howToVC.hero.isEnabled = true
        //            howToVC.hero.modalAnimationType = .selectBy(presenting: .pageIn(direction: .up), dismissing: .pageOut(direction: .down))
        //            present(howToVC, animated: true, completion: nil)
        //        case 1:
        //            if #available(iOS 10.3, *) {
        //                SKStoreReviewController.requestReview()
        //            } else {
        //                MDCAlert.showAlert(vc: self, title: "😥", message: "申し訳ございません。現在のOSバージョンではご利用になれません。", isEnableOutsideScreenTouch: true, positiveAction: {})
        //            }
        //        case 2:
        //            let url = URL(string: "https://twitter.com/enyyokii")!
        //            if UIApplication.shared.canOpenURL(url) {
        //                UIApplication.shared.open(url)
        //            }
        //        default:
        //            break
        //        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
