//
//  NotificationManager.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/05/12.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import NotificationCenter
import UserNotifications
import RealmSwift

class NotificationManager {
    static let sharedInstance = NotificationManager()
    
    private init(){}
    
    // TOOD: 許可タイミングの検討：　リーディングリスト画面に入って、初回ダイアログ消えた時
    func requestAuthorize(vc: UNUserNotificationCenterDelegate) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
            
                if error != nil {
                    print("エラー：\(String(describing: error?.localizedDescription))")
                    return
                }
                
                if granted {
                    print("通知許可")
                    let center = UNUserNotificationCenter.current()
                    center.delegate = vc
                    
                } else {
                    print("通知拒否")
                }
            })
        }
    }

    private func addNotificationContent(type: LocalNotificationType, trigger: UNNotificationTrigger) {
        switch type {
        case .OneDayBefore:
            createOneDayBeforeNotification(trigger: trigger)
        case .TwoDaysBefore:
            createTwoDaysBeforeNotification(trigger: trigger)
        }
    }
    
    private func createNotificationTrigger(type: LocalNotificationType) -> UNNotificationTrigger {
        var notificationTime = DateComponents()
        var trigger: UNNotificationTrigger
        
        switch type {
        case .OneDayBefore:
            notificationTime.hour = 13
            notificationTime.minute = 0
        case .TwoDaysBefore:
            notificationTime.hour = 10
            notificationTime.minute = 0
        }
        trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
        return trigger
    }

    /// 期限1日後の通知を作成
    private func createOneDayBeforeNotification(trigger: UNNotificationTrigger) {
        if let items = RealmManager.sharedInstance.readItemsByDueDateOneDayAfter() {
            items.forEach { item in
                // 通知コンテンツを作成
                let content = UNMutableNotificationContent()
                content.title = item.title
                content.body = Constant.LocalNotification.body
                content.sound = UNNotificationSound.default
                let typeId = Constant.LocalNotification.id.onwDayBefore
                let id = "\(typeId): \(item.title)"
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                // 通知をセット
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }
    
    /// 期限2日後の通知を作成
    private func createTwoDaysBeforeNotification(trigger: UNNotificationTrigger) {
        if let items = RealmManager.sharedInstance.readItemsByDueDateTowDaysAfter() {
            items.forEach { item in
                // 通知コンテンツを作成
                let content = UNMutableNotificationContent()
                content.title = item.title
                content.body = Constant.LocalNotification.body
                content.sound = UNNotificationSound.default
                let typeId = Constant.LocalNotification.id.twoDaysBefore
                let id = "\(typeId): \(item.title)"
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                // 通知をセット
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }
}
