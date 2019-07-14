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

// notificationについて参考： https://qiita.com/aokiplayer/items/3f02453af743a54de718

class NotificationManager {
    static let sharedInstance = NotificationManager()
    
    private init(){}
    
    // TOOD: 許可タイミングの検討：　リーディングリスト画面に入って、初回ダイアログ消えた時
    
    // vc: UNUserNotificationCenterDelegate
    func requestAuthorize() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                
                if error != nil {
                    print("エラー：\(String(describing: error?.localizedDescription))")
                    return
                }
                
                if granted {
                    print("通知許可")
//                    let center = UNUserNotificationCenter.current()
//                    center.delegate = vc
                    
                } else {
                    print("通知拒否")
                }
            })
        }
    }
    
    func addNotification(item: ReadingItem, type: LocalNotificationType) {
        guard let dueDate = item.dueDate else { return }
        
        var trigger: UNNotificationTrigger!
        // 通知指定日時
        var dateComponents: DateComponents!
        // 指定日時計算用Calender
        let calendar = Calendar.current
        // 通知指定日時（Date型）
        var notificationDate: Date!
        
        let content = UNMutableNotificationContent()
        content.title = item.title
        // fixme
        content.body = Constant.LocalNotification.body
        content.sound = UNNotificationSound.default
        var typeId: String!
        
        switch type {
        case .OneDayBefore:
            // 通知時間設定
            notificationDate = calendar.date(byAdding: .day, value: -1, to: dueDate)
            let year = calendar.component(.year, from: notificationDate)
            let month = calendar.component(.month, from: notificationDate)
            let day = calendar.component(.day, from: notificationDate)
            let hour = calendar.component(.hour, from: notificationDate)
            let minute = calendar.component(.minute, from: notificationDate)
            
            dateComponents = DateComponents(timeZone: TimeZone.init(identifier: TimeZone.current.identifier), year: year, month: month, day: day, hour: hour, minute: minute)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // 通知id
            typeId = Constant.LocalNotification.id.onwDayBefore
        case .TwoDaysBefore:
            // 通知時間設定
            notificationDate = calendar.date(byAdding: .day, value: -2, to: dueDate)
            let year = calendar.component(.year, from: notificationDate)
            let month = calendar.component(.month, from: notificationDate)
            let day = calendar.component(.day, from: notificationDate)
            let hour = calendar.component(.hour, from: notificationDate)
            let minute = calendar.component(.minute, from: notificationDate)
            
            dateComponents = DateComponents(timeZone: TimeZone.init(identifier: TimeZone.current.identifier), year: year, month: month, day: day, hour: hour, minute: minute)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // 通知id
            typeId = Constant.LocalNotification.id.twoDaysBefore
        }
        
        // 通知内容を設定
        let id = "\(String(describing: typeId)): \(item.title)"
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func deleteNotification(item: ReadingItem) {
        let id1 = "\(Constant.LocalNotification.id.twoDaysBefore): \(item.title)"
        let id2 = "\(Constant.LocalNotification.id.onwDayBefore): \(item.title)"
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id1, id2])
    }
}
