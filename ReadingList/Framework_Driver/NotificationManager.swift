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
final class NotificationClient: NotificationClientProtocol {
    
    func requestAuthorize() {
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
    
    func registerOneDayBeforePush(id: String, title: String, targetDate: Date) {
        
        addNotification(id: id, title: title, targetDate: targetDate, type: .OneDayBefore)
    }
    
    func registerTwoDaysBeforePush(id: String, title: String, targetDate: Date) {
        
        addNotification(id: id, title: title, targetDate: targetDate, type: .TwoDaysBefore)
    }
    
    func deleteNotification(id: String) {
        let id1 = "\(Constant.LocalNotification.id.twoDaysBefore): \(id)"
        let id2 = "\(Constant.LocalNotification.id.onwDayBefore): \(id)"
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id1, id2])
    }
    
    private func addNotification(id: String, title: String, targetDate: Date, type: LocalNotificationType) {
        
        var trigger: UNNotificationTrigger!
        // 通知指定日時
        var dateComponents: DateComponents!
        // 指定日時計算用Calender
        let calendar = Calendar.current
        // 通知指定日時（Date型）
        var notificationDate: Date!
        
        let content = UNMutableNotificationContent()
        content.title = "【積ん読注意🔥】\(title)"
        content.sound = UNNotificationSound.default
        var notificationId: String!
        
        switch type {
        case .OneDayBefore:
            content.body = Constant.LocalNotification.onwDayBeforeBody
            
            // 通知時間設定
            notificationDate = calendar.date(byAdding: .day, value: -1, to: targetDate)
            let year = calendar.component(.year, from: notificationDate)
            let month = calendar.component(.month, from: notificationDate)
            let day = calendar.component(.day, from: notificationDate)
            let hour = calendar.component(.hour, from: notificationDate)
            let minute = calendar.component(.minute, from: notificationDate)
            
            dateComponents = DateComponents(timeZone: TimeZone.init(identifier: TimeZone.current.identifier), year: year, month: month, day: day, hour: hour, minute: minute)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // 通知id
            notificationId = "\(Constant.LocalNotification.id.twoDaysBefore): \(title)"
        case .TwoDaysBefore:
            content.body = Constant.LocalNotification.twoDaysBeforeBody
            
            // 通知時間設定
            notificationDate = calendar.date(byAdding: .day, value: -2, to: targetDate)
            let year = calendar.component(.year, from: notificationDate)
            let month = calendar.component(.month, from: notificationDate)
            let day = calendar.component(.day, from: notificationDate)
            let hour = calendar.component(.hour, from: notificationDate)
            let minute = calendar.component(.minute, from: notificationDate)
            
            dateComponents = DateComponents(timeZone: TimeZone.init(identifier: TimeZone.current.identifier), year: year, month: month, day: day, hour: hour, minute: minute)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // 通知id
            notificationId = "\(Constant.LocalNotification.id.onwDayBefore): \(id)"
        }
        
        // 通知内容を設定
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
