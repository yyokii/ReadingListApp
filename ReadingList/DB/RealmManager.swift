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
    
    /// 記事データ編集 TODO: bool返すようにしたい, error型か
    func editReadingItem(url: String, title: String, imageUrl: String, createdDate: Date?, finishedDate: Date?, item: ReadingItem) {
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
                object.finishedDate = Date()
            }
        } else {
            // 未読
            try? database?.write {
                object.finishedDate = nil
            }
        }
    }
    
    /// 読み終わってるものを全て取得
    func readFinishedItems() -> Results<ReadingItem>?  {
        return database?.objects(ReadingItem.self).filter("finishedDate != null && isDeleted == false")
    }
    
    /// 読み終わっていないものを全て取得
    func readNotFinishedItems() -> Results<ReadingItem>?  {
        return database?.objects(ReadingItem.self).filter("finishedDate == null && isDeleted == false")
    }
    
    /// 読み終わってない且つ期限日が１日後のアイテムを取得
    func readItemsByDueDateOneDayAfter() -> Results<ReadingItem>?  {
        let date = Date.getDueDate(addingDaysValue: 1)
        guard let dueDate = date else { return nil }
        let results = database?.objects(ReadingItem.self).filter("finishedDate == null && dueDate <= %@ && isDeleted == false", dueDate)
        
        return results
    }
    
    /// 読み終わってない且つ期限日が2日後のアイテムを取得
    func readItemsByDueDateTowDaysAfter() -> Results<ReadingItem>?  {
        let date1 = Date.getDueDate(addingDaysValue: 1)
        let date2 = Date.getDueDate(addingDaysValue: 2)
        
        guard let dueDate1 = date1, let dueDate2 = date2 else { return nil }
        let results = database?.objects(ReadingItem.self).filter("finishedDate == null && dueDate > %@ && dueDate <= %@ && isDeleted == false", dueDate1, dueDate2)
        
        return results
    }
    
    /// TODO: 期日切れのアイテムを削除
    func deleteOverdueItem() {
//        let fileterdItem = database?.objects(ReadingItem.self).filter("title == %@ && url == %@", readingItem.title, readingItem.url)
//
//        guard let results = fileterdItem else { return }
//        try? database?.write {
//            database?.delete(results)
//        }
    }
    
    /// タイトルとURLが一致するものを削除
    func deleteItem(title: String, url: String) {
        let fileterdItem = database?.objects(ReadingItem.self).filter("title == %@ && url == %@ && isDeleted == false", title, url)
        
        // TODO: これ複数ある場合の適切な対応は？
        guard let results = fileterdItem else { return }
        try? database?.write {
            results.first?.isDeleted = true
        }
    }
}
