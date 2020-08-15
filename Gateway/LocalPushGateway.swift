//
//  LocalPushGateway.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/16.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

final class LocalPushGateway: LocalPushGatewayProtocol {

    var notificationClient: NotificationClient!

    func registerOneDayBeforePush(id: String, title: String, targetDate: Date) {
        
        notificationClient.registerOneDayBeforePush(id: id, title: title, targetDate: targetDate)
    }
    
    func registerTwoDaysBeforePush(id: String, title: String, targetDate: Date) {
        
        notificationClient.registerTwoDaysBeforePush(id: id, title: title, targetDate: targetDate)

    }
    
    func deleteNotification(id: String) {
        
        notificationClient.deleteNotification(id: id)
    }
}
