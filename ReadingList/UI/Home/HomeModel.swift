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
    func expireOneDayItems() -> Results<ReadingItem>?
    func expireTwoDaysItems() -> Results<ReadingItem>?
    func expireThreeDaysItems() -> Results<ReadingItem>?
    func expireFourDaysItems() -> Results<ReadingItem>?
    func expireFiveDaysItems() -> Results<ReadingItem>?
    func expireSixDaysItems() -> Results<ReadingItem>?
    func expireSevenDaysItems() -> Results<ReadingItem>?
    func fetchNotFinishedItems() -> Results<ReadingItem>?
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
    
    /// 期限日が1日以内のものの件数を返す
    func expireOneDayItems() -> Results<ReadingItem>? {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 1) else { return nil }
        return res
    }
    
    /// 期限日が1日より長く、2日以内のものの件数を返す
    func expireTwoDaysItems() -> Results<ReadingItem>? {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 2) else { return nil }
        return res
    }
    
    /// 期限日が2日より長く、3日以内のものの件数を返す
    func expireThreeDaysItems() -> Results<ReadingItem>? {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 3) else { return nil }
        return res
    }
    
    /// 期限日が3日より長く、4日以内のものの件数を返す
    func expireFourDaysItems() -> Results<ReadingItem>? {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 4) else { return nil }
        return res
    }
    
    /// 期限日が4日より長く、5日以内のものの件数を返す
    func expireFiveDaysItems() -> Results<ReadingItem>? {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 5) else { return nil }
        return res
    }
    
    /// 期限日が5日より長く、6日以内のものの件数を返す
    func expireSixDaysItems() -> Results<ReadingItem>? {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 6) else { return nil }
        return res
    }
    
    /// 期限日が6日より長く、7日以内のものの件数を返す
    func expireSevenDaysItems() -> Results<ReadingItem>? {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 7) else { return nil }
        return res
    }
    
    func fetchNotFinishedItems() -> Results<ReadingItem>? {
        guard let res = RealmManager.sharedInstance.readNotFinishedItems() else { return nil }
        return res
    }
}
