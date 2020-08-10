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
                    
                } else {
                    print("通知拒否")
                }
            })
        }
    }
    
    // テスト
//    func testNotification(type: LocalNotificationType) {
//        var trigger: UNNotificationTrigger!
//        // 通知指定日時
//        var dateComponents: DateComponents!
//        
//        let content = UNMutableNotificationContent()
//        content.sound = UNNotificationSound.default
//        var typeId: String!
//        
//        switch type {
//        case .OneDayBefore:
//            content.title = "【積ん読注意🔥】Yomuについて知る"
//            content.body = Constant.LocalNotification.onwDayBeforeBody
//            
//            dateComponents = DateComponents(timeZone: TimeZone.init(identifier: TimeZone.current.identifier), year: 2019, month: 8, day: 4, hour: 4, minute: 43)
//            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//            typeId = "test1"
//        case .TwoDaysBefore:
//            content.title = "【積ん読注意🔥】リーディングリストって溜まりがち。。"
//            content.body = Constant.LocalNotification.twoDaysBeforeBody
//            
//            dateComponents = DateComponents(timeZone: TimeZone.init(identifier: TimeZone.current.identifier), year: 2019, month: 8, day: 4, hour: 4, minute: 44)
//            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//            typeId = "test2"
//        }
//        let request = UNNotificationRequest(identifier: typeId, content: content, trigger: trigger)
//        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//    }
    
    func addNotification(item: ReadingListItem, type: LocalNotificationType) {
        guard let dueDate = item.dueDate?.dateValue() else { return }
        
        var trigger: UNNotificationTrigger!
        // 通知指定日時
        var dateComponents: DateComponents!
        // 指定日時計算用Calender
        let calendar = Calendar.current
        // 通知指定日時（Date型）
        var notificationDate: Date!
        
        let content = UNMutableNotificationContent()
        content.title = "【積ん読注意🔥】\(item.title)"
        content.sound = UNNotificationSound.default
        var notificationId: String!
        
        switch type {
        case .OneDayBefore:
            content.body = Constant.LocalNotification.onwDayBeforeBody
            
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
            notificationId = "\(Constant.LocalNotification.id.twoDaysBefore): \(item.title)"
        case .TwoDaysBefore:
            content.body = Constant.LocalNotification.twoDaysBeforeBody
            
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
            notificationId = "\(Constant.LocalNotification.id.onwDayBefore): \(item.title)"
        }
        
        // 通知内容を設定
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func deleteNotification(item: ReadingListItem) {
        let id1 = "\(Constant.LocalNotification.id.twoDaysBefore): \(item.title)"
        let id2 = "\(Constant.LocalNotification.id.onwDayBefore): \(item.title)"
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id1, id2])
    }
}
