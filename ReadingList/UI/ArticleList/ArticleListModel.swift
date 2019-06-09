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
    func deleteItem(from articleItem: Article)
}

final class ArticleListModel: ArticleListModelInput {
    func addItemToRealm(from articleItem: Article) {
        let readingItem = ReadingItem()
        readingItem.title = articleItem.title
        readingItem.url = articleItem.url
        
        let now = Date()
        readingItem.createdDate = now
        // 一週間後の日付（=読み終わり予定の期限日）を取得
        let calendar = Calendar.current
        let dueDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: now)
        readingItem.dueDate = dueDate

        readingItem.finishedDate = nil
        RealmManager.sharedInstance.addReadingItem(object: readingItem)
    }
    
    /// アイテムをリーディングリストから削除
    func deleteItem(from articleItem: Article) {
        RealmManager.sharedInstance.deleteItem(title: articleItem.title, url: articleItem.url)
    }
}
