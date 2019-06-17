//
//  ListModel.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/14.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

/**
 アイテム追加パターン
 ① シェアする（ dic → realm ）
 ② 追加する（ realm ）
 */

protocol ListModelInput {
    func addItemToRealm(from dicItems: [[String:String]])
    // func addItemToRealm(title: String, url: String)
    func changeItemStateToReading(item: ReadingItem)
    func changeItemStateToFinished(item: ReadingItem)
    func deleteItem(readingItem: ReadingItem)
}

final class ListModel: ListModelInput {
    
//    func addItemToRealm(title: String, url: String) {
//        let readingItem = ReadingItem()
//        readingItem.title = title
//        readingItem.url = url
//        readingItem.createdDate =  Date()
//        // FIXME: 期限を設定する
//        readingItem.finishedDate = nil
//    }

    /// 配列に格納されているアイテムをrealmに変換し保存
    func addItemToRealm(from dicItems: [[String:String]]) {
        dicItems.forEach { (item: [String:String]) in
            let obj = createRealmObj(itemDic: item)
            guard let readingItem = obj else { return }
            RealmManager.sharedInstance.addReadingItem(object: readingItem)
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
            
            let fotmatter = Date().getFormatter()
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
        RealmManager.sharedInstance.deleteItem(title: readingItem.title, url: readingItem.url)
    }
    
    // アイテムをリーディングリストに戻す
    func changeItemStateToReading(item: ReadingItem) {
        RealmManager.sharedInstance.updateReadingItemFinishedState(object: item, isFinished: false)
    }
    
    // アイテムを既読にする
    func changeItemStateToFinished(item: ReadingItem) {
        RealmManager.sharedInstance.updateReadingItemFinishedState(object: item, isFinished: true)
    }
}
