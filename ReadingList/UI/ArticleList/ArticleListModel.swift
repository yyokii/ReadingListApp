//
//  ArticleListModel.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/06/05.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol ArticleListModelInput {
    func addItemToRealm(from articleItem: Article)
}

final class ArticleListModel: ArticleListModelInput {
    
    /// Article型を変換してリーディングリストに追加する
    func addItemToRealm(from articleItem: Article) {
        let readingItem = ReadingItem()
        readingItem.title = articleItem.title
        readingItem.url = articleItem.url
        
        if let imageUrlString = articleItem.imageUrl {
            readingItem.imageUrl = imageUrlString
        }
        
        let now = Date()
        readingItem.createdDate = now
        // 一週間後の日付（=読み終わり予定の期限日）を取得
        let calendar = Calendar.current
        let dueDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: now)
        readingItem.dueDate = dueDate

        readingItem.finishedDate = nil
        RealmManager.sharedInstance.addReadingItem(object: readingItem)
        // duedate前の通知設定
        NotificationManager.sharedInstance.addNotification(item: readingItem, type: .OneDayBefore)
        NotificationManager.sharedInstance.addNotification(item: readingItem, type: .TwoDaysBefore)
    }
}
