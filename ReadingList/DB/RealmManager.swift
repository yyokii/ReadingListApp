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
        return database?.objects(ReadingItem.self).filter("finishedDate != null")
    }
    
    /// 読み終わっていないものを全て取得
    func readNotFinishedItems() -> Results<ReadingItem>?  {
        return database?.objects(ReadingItem.self).filter("finishedDate == null")
    }
    
    /// 読み終わってない且つ期限日が１日後のアイテムを取得
    func readItemsByDueDateOneDayAfter() -> Results<ReadingItem>?  {
        let date = getDueDate(addingDaysValue: 1)
        guard let dueDate = date else { return nil }
        let results = database?.objects(ReadingItem.self).filter("finishedDate == null && dueDate <= %@", dueDate)
        
        return results
    }
    
    /// 読み終わってない且つ期限日が2日後のアイテムを取得
    func readItemsByDueDateTowDaysAfter() -> Results<ReadingItem>?  {
        let date1 = getDueDate(addingDaysValue: 1)
        let date2 = getDueDate(addingDaysValue: 2)
        
        guard let dueDate1 = date1, let dueDate2 = date2 else { return nil }
        let results = database?.objects(ReadingItem.self).filter("finishedDate == null && dueDate > %@ && dueDate <= %@", dueDate1, dueDate2)
        
        return results
    }
    
    /// 数日後（引き数日後）の日付を取得する
    private func getDueDate(addingDaysValue: Int) -> Date? {
        // 今日の終わりのDateを取得
        let todayEndDate = endOfDayForDate(date: Date())
        guard let endDate = todayEndDate else { return nil }
        
        // 期限の日付を取得
        let calendar = Calendar.current
        let dateByAdding = calendar.date(byAdding: .day, value: addingDaysValue, to: endDate)
        guard let dueDate = dateByAdding else { return nil }
        
        // 期限の日付をフォーマッターで加工しdate型で作成
        let formatter = Date().getFormatter()
        let formattedString = formatter.string(from: dueDate)
        let formattedDate = formatter.date(from: formattedString)
        guard let date = formattedDate else { return nil }
        return date
    }
    
    // TODO:extension dateの最終時を取得
    private func endOfDayForDate(date: Date) -> Date? {
        let cal = Calendar.current
        var components = DateComponents()
        components.day = 1
        let addedOneDayDate = cal.date(byAdding: components, to: cal.startOfDay(for: date))
        let endDate = addedOneDayDate?.addingTimeInterval(-1)
        return endDate
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
        let fileterdItem = database?.objects(ReadingItem.self).filter("title == %@ && url == %@", title, url)
        
        guard let results = fileterdItem else { return }
        try? database?.write {
            database?.delete(results)
        }
    }
}
