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
    func addItemToRealm(title: String, url: String)
    func deleteItem(readingItem: ReadingItem)
}

final class ListModel: ListModelInput {
    func addItemToRealm(title: String, url: String) {
        let readingItem = ReadingItem()
        readingItem.title = title
        readingItem.url = url
        readingItem.createdDate =  Date()
        readingItem.finishedDate = nil
    }

    /// 配列に格納されているアイテムをrealmに変換し保存
    func addItemToRealm(from dicItems: [[String:String]]) {
        dicItems.forEach { (item: [String:String]) in
            let obj = createRealmObj(itemDic: item)
            guard let readingItem = obj else { return }
            RealmManager.sharedInstance.addReadingItem(object: readingItem)
        }
    }
    
    /// 特定のアイテムを削除
    func deleteItem(readingItem: ReadingItem) {
        RealmManager.sharedInstance.deleteItem(readingItem: readingItem)
    }
    
    /// dicからRealmオブジェクトを生成
    private func createRealmObj(itemDic: [String:String]) -> ReadingItem? {
        if let title = itemDic[Constant.readingItem.title],
            let url = itemDic[Constant.readingItem.url],
            let createdDate = itemDic[Constant.readingItem.createdDate],
            let finishedDate = itemDic[Constant.readingItem.finishedDate] {
            
            let readingItem = ReadingItem()
            readingItem.title = title
            readingItem.url = url
            
            let fotmatter = Date().getFormatter()
            readingItem.createdDate = fotmatter.date(from: createdDate)
            readingItem.finishedDate = fotmatter.date(from: finishedDate)
            return readingItem
        } else {
            return nil
        }
    }
}
