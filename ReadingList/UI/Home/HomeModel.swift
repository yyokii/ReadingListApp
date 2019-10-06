//
//  HomeModel.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol HomeModelInput {
    func addItemToRealm(from dicItems: [[String:String]])
    func fetchNotFinishedItems() -> Results<ReadingItem>?
    func deleteItem(readingItem: ReadingItem)
    func changeItemStateToReading(item: ReadingItem)
}

final class HomeModel: HomeModelInput {
    /// 配列に格納されているアイテムをrealmに変換し保存
    func addItemToRealm(from dicItems: [[String:String]]) {
        dicItems.forEach { (item: [String:String]) in
            let obj = createRealmObj(itemDic: item)
            guard let readingItem = obj else { return }
            RealmManager.sharedInstance.addReadingItem(object: readingItem)
            // duedate前の通知設定
            NotificationManager.sharedInstance.addNotification(item: readingItem, type: .OneDayBefore)
            NotificationManager.sharedInstance.addNotification(item: readingItem, type: .TwoDaysBefore)
        }
    }
    
    /// dicからRealmオブジェクトを生成
    private func createRealmObj(itemDic: [String:String]) -> ReadingItem? {
        if let title = itemDic[Constant.ReadingItem.title],
            let url = itemDic[Constant.ReadingItem.url],
            let createdDate = itemDic[Constant.ReadingItem.createdDate],
            let dueDate = itemDic[Constant.ReadingItem.dueDate],
            let finishedDate = itemDic[Constant.ReadingItem.finishedDate] {
            
            let readingItem = ReadingItem()
            readingItem.title = title
            readingItem.url = url
            
            let fotmatter = Date.getFormatter()
            readingItem.createdDate = fotmatter.date(from: createdDate)
            readingItem.dueDate = fotmatter.date(from: dueDate)
            readingItem.finishedDate = fotmatter.date(from: finishedDate)
            return readingItem
        } else {
            return nil
        }
    }
    
    /// 特定のアイテムを削除
    func deleteItem(readingItem: ReadingItem) {
        RealmManager.sharedInstance.deleteItem(title: readingItem.title, url: readingItem.url, createdDate: readingItem.createdDate!)
    }
    
    // アイテムを既読にする
    func changeItemStateToReading(item: ReadingItem) {
        RealmManager.sharedInstance.updateReadingItemFinishedState(object: item, isFinished: true)
    }
    
    func fetchNotFinishedItems() -> Results<ReadingItem>? {
        guard let res = RealmManager.sharedInstance.readNotFinishedItems() else { return nil }
        return res
    }
}
