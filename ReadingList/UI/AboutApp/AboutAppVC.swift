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
    let current = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "このアプリについて"
        confirureTableView()
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutAppTableViewCell", for: indexPath) as! AboutAppTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "🤟 3 TODO とは？"
        case 1:
            cell.titleLabel.text = "😍 レビューする"
        case 2:
            cell.titleLabel.text = "👩‍💻 開発した人　：　@enyyokii"
        default:
            cell.titleLabel.text = ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
