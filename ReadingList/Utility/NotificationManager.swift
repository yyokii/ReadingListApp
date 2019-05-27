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
    
    // TOOD: 許可タイミングの検討：　初回のスライド終わったときかなと
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
    
    // TODO : 期限切れそうなものを通知する（１週間後が期限、2日前の10時、1日前の13時）
    
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
    
    private func addNotificationContent(type: LocalNotificationType, trigger: UNNotificationTrigger) {
        if let items = RealmManager.sharedInstance.readNotFinishedItems() {
            items.forEach { item in
                // 通知コンテンツを作成
                let content = UNMutableNotificationContent()
                content.title = item.title
                content.body = Constant.LocalNotification.body
                content.sound = UNNotificationSound.default
                
                var typeId = ""
                switch type {
                case .OneDayBefore:
                    typeId = Constant.LocalNotification.id.onwDayBefore
                case .TwoDaysBefore:
                    typeId = Constant.LocalNotification.id.twoDaysBefore
                }
                
                let id = "\(typeId): \(item.title)"
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                // 通知をセット
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }
}
