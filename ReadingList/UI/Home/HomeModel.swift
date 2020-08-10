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

    //    func addItemToRealm(from dicItems: [[String:String]])
    func fetchNotFinishedItems() -> [ReadingListItem]
    func deleteItem(readingItem: ReadingListItem)
    func changeItemStateToReading(item: ReadingListItem)
}

final class HomeModel: HomeModelInput {
    func fetchNotFinishedItems() -> [ReadingListItem] {
        return [ReadingListItem]()
    }
    
    func deleteItem(readingItem: ReadingListItem) {
        // TODO: delete
    }
    
    func changeItemStateToReading(item: ReadingListItem) {
        // TODO: delete
    }
    
//    /// 特定のアイテムを削除
//    func deleteItem(readingItem: ReadingItem) {
//        RealmManager.sharedInstance.deleteItem(title: readingItem.title, url: readingItem.url, createdDate: readingItem.createdDate!)
//    }
//    
//    // アイテムを既読にする
//    func changeItemStateToReading(item: ReadingItem) {
//        RealmManager.sharedInstance.updateReadingItemFinishedState(object: item, isFinished: true)
//    }
//    
//    func fetchNotFinishedItems() -> Results<ReadingItem>? {
//        guard let res = RealmManager.sharedInstance.readNotFinishedItems() else { return nil }
//        return res
//    }
}
