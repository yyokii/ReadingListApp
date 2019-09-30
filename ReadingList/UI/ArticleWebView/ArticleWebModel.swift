//
//  ArticleWebModel.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/07/06.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol ArticleWebModelInput {
    func addItemToReadingList(item: ReadingItem)
    func addItemToFinishedList(item: ReadingItem)
}

final class ArticleWebModel: ArticleWebModelInput {
    
    /// リーディングリストに保存する
    func addItemToReadingList(item: ReadingItem) {
//        let readingItem = ReadingItem()
//        readingItem.title = webItem.title
//        readingItem.url = webItem.url
//
//        if let imageUrlString = webItem.imageUrl, imageUrlString != "" {
//            readingItem.imageUrl = imageUrlString
//        }
//
//        let now = Date()
//        readingItem.createdDate = now
//        // 一週間後の日付（=読み終わり予定の期限日）を取得
//        let calendar = Calendar.current
//        let dueDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: now)
//        readingItem.dueDate = dueDate
//
//        readingItem.finishedDate = nil
//        RealmManager.sharedInstance.addReadingItem(object: readingItem)
    }
    
    /// 読み終わりアイテムに保存する
    func addItemToFinishedList(item: ReadingItem) {
//        let readingItem = ReadingItem()
//        readingItem.title = webItem.title
//        readingItem.url = webItem.url
//        
//        if let imageUrlString = webItem.imageUrl, imageUrlString != "" {
//            readingItem.imageUrl = imageUrlString
//        }
//        
//        let now = Date()
//        readingItem.createdDate = now
//        readingItem.finishedDate = now
//        readingItem.dueDate = nil
//        RealmManager.sharedInstance.addReadingItem(object: readingItem)
    }
}

