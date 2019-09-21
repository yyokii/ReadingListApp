//
//  Notification+Extension.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/14.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    // MARL: アイテムオプション
    
    // 閉じる
    static let dismissItemOption = Notification.Name("dismissItemOption")
    
    // リーディングリストに戻す
    static let changeItemStateToReading = Notification.Name("changeItemStateToReading")
    
    // 読み終わったものにする
    static let changeItemStateToFinishedReading = Notification.Name("changeItemStateToFinishedReading")
    
    // アイテムの削除
    static let deleteReadingItem = Notification.Name("deleteReadingItem")
    static let deleteFinishedItem = Notification.Name("deleteFinishedItem")
    
    // リストの更新
    static let updateReadingList = Notification.Name("updateReadingList")
    static let updateFinishedList = Notification.Name("updateFinishedList")
}
