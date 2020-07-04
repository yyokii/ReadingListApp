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
    
    private let aboutAppCellIdentifier = "AboutAppTableViewCell"
    private let notificationStateCellIdentifier = "NotificationAuthStateCell"
    let notificationCenter = NotificationCenter.default
    
    private let cellTitles = [
        ["「Yomu」の使い方"],
        ["最近削除したもの", "通知設定"],
        ["開発した人"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "このアプリについて"
        notificationCenter.addObserver(self, selector: #selector(updateNorificationAuthState), name: UIApplication.willEnterForegroundNotification, object: nil)
        confirureTableView()
    }
    
    func confirureTableView() {
        tableView.register(UINib(nibName: "AboutAppTableViewCell", bundle: nil), forCellReuseIdentifier: aboutAppCellIdentifier)
        tableView.register(UINib(nibName: "SwitchBtnTableViewCell", bundle: nil), forCellReuseIdentifier: notificationStateCellIdentifier)
    }
    
    @objc private func updateNorificationAuthState() {
        guard let _ = view.window else { return }
        
        let notificationAuthStateIndexPath = IndexPath(row: 1, section: 1)
        tableView.reloadRows(at: [notificationAuthStateIndexPath], with: .none)
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
        
        if indexPath.section == 1 && indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: notificationStateCellIdentifier, for: indexPath) as! SwitchBtnTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: aboutAppCellIdentifier, for: indexPath) as! AboutAppTableViewCell
            let title = cellTitles[indexPath.section][indexPath.row]
            cell.titleLabel.text = title
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                SwiftMessageUtil.showTutorialDialog()
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                let deleteListVC = DeletedListVC.viewController()
                navigationController?.pushViewController(deleteListVC, animated: true)
            case 1:
                break
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
