//
//  NotificationClientProtocol.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/16.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol NotificationClientProtocol {
    
    func requestAuthorize()
    
    /// 1日前のローカルプッシュを登録する
    func registerOneDayBeforePush(id: String, title: String, targetDate: Date)
    
    /// 2日前のローカルプッシュを登録する
    func registerTwoDaysBeforePush(id: String, title: String, targetDate: Date)
    
    /// 任意のIDを持つ通知を削除する
    func deleteNotification(id: String)
}
