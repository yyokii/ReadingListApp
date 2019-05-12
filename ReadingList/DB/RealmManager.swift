//
//  RealmManager.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/20.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import RealmSwift

class RealmManager {
    static let sharedInstance = RealmManager()
    private var database: Realm?
    
    private init() {
        database = try? Realm()
        print("------Realm file------")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        print("------------")
    }
    
    /// 記事データ書き込み
    func addReadingItem(object: ReadingItem) {
        try? database?.write {
            database?.add(object)
        }
    }
    
    /// 記事データ編集 FIXME: bool返すようにしたい, error型か
    func editReadingItem(url: String, title: String, imageUrl: String, createdDate: String, finishedDate: String, item: ReadingItem) {
        try? database?.write {
            item.url = url
            item.title = title
            item.createdDate = createdDate
            item.finishedDate = finishedDate
        }
    }
    
    /// 記事の読んだかどうかの状態を変更
    func updateReadingItemFinishedState(object: ReadingItem, isFinished: Bool) {
        if isFinished {
            // 読み終わった
            try? database?.write {
                object.finishedDate = Date().formattedToday()
            }
        } else {
            // 未読
            try? database?.write {
                object.finishedDate = ""
            }
        }
    }
    
    /// 記事アイテムを全て取得
    func readItems() -> Results<ReadingItem>? {
        let results = database!.objects(ReadingItem.self)
        return results
    }
    
    /// 読み終わっていないものを全て取得
    func readNotFinishedItems() -> Results<ReadingItem>?  {
        return database?.objects(ReadingItem.self).filter("finishedDate == %@", "")
    }
    
    /// タイトルとURLが一致するものを削除
    func deleteItem(readingItem: ReadingItem) {
        let fileterdItem = database?.objects(ReadingItem.self).filter("title == %@ && url == %@", readingItem.title, readingItem.url)
        
        guard let results = fileterdItem else { return }
        try? database?.write {
            database?.delete(results)
        }
    }
}
