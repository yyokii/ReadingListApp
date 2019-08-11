//
//  RealmManager.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/20.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import RealmSwift

/// ReadingItemモデル管理クラス
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
        return database?.objects(ReadingItem.self).filter("finishedDate == null && isDeleted == false").sorted(byKeyPath: "dueDate")
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
    
    /// 特定の日に追加されたアイテムを取得
    func readItemsAddedOn(date: Date) -> Results<ReadingItem>?  {
        let startOfDay = date.startOfDay
        let endOfDay = date.endOfDay
        
        let results = database?.objects(ReadingItem.self).filter("dueDate > %@ && dueDate <= %@ && isDeleted == false", startOfDay, endOfDay)
        return results
    }
    
    /// 1週間以内に読み終わりになったアイテムを取得
    func readItemsFinishedItems() -> Results<ReadingItem>?  {
        let now = Date()
        let date = Date(timeInterval: -60*60*24*30, since: now)
        
        let startOfDay = date.startOfDay
        let endOfDay = now.endOfDay
        
        let results = database?.objects(ReadingItem.self).filter("finishedDate >= %@ && finishedDate <= %@ && isDeleted == false", startOfDay, endOfDay)
        return results
    }

    /// 論理削除されているアイテムを取得
    func readDeletedItems() -> Results<ReadingItem>?  {
        let results = database?.objects(ReadingItem.self).filter("isDeleted == true")
        return results
    }
    
    /// TODO: 動作確認、期日切れのアイテムを論理削除
    func deleteExpiredItem(now: Date) {
        // 削除されていない、期限日を超えているもの、読み終わっていないもの
        let fileterdItem = database?.objects(ReadingItem.self).filter("finishedDate == null && dueDate < %@ && isDeleted == false", now)
        guard let results = fileterdItem else { return }
        
        results.forEach { item in
            try? database?.write {
                item.isDeleted = true
            }
        }
    }
    
    /// TODO: 動作確認、論理削除されている且つ、作成日から30日以上経過しているものを削除
    func deleteItem(now: Date) {
        let date = NSDate(timeInterval: -60*60*24*30, since: now)
        
        let fileterdItem = database?.objects(ReadingItem.self).filter("createdDate < %@ && isDeleted == true", date)
        guard let results = fileterdItem else { return }
        
        results.forEach { item in
            try? database?.write {
                item.isDeleted = true
            }
        }
    }
    
    /// タイトルとURL、作成日が一致するものを論理削除
    func deleteItem(title: String, url: String, createdDate: Date) {
        let fileterdItem = database?.objects(ReadingItem.self).filter("title == %@ && url == %@ && createdDate == %@ && isDeleted == false", title, url, createdDate)
        
        guard let results = fileterdItem else { return }
        try? database?.write {
            results.first?.isDeleted = true
        }
    }
}
