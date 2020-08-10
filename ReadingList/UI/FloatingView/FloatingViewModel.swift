//
//  FloatingViewModel.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/09/01.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol FloatingViewModelInput {
    func changeItemStateToReading(item: ReadingListItem)
    func deleteItem(readingItem: ReadingListItem)
    func fetchFinishedItems() -> [ReadingListItem]
}

final class FloatingViewModel: FloatingViewModelInput {
    func changeItemStateToReading(item: ReadingListItem) {
        // TODO: fix
    }
    
    func deleteItem(readingItem: ReadingListItem) {
        // TODO: fix
    }
    
    func fetchFinishedItems() -> [ReadingListItem] {
        // TODO: fix
        return [ReadingListItem]()
    }
    

//    /// 特定のアイテムを削除
//    func deleteItem(readingItem: ReadingItem) {
//        RealmManager.sharedInstance.deleteItem(title: readingItem.title, url: readingItem.url, createdDate: readingItem.createdDate!)
//    }
//
//    // アイテムをリーディングリストに戻す
//    func changeItemStateToReading(item: ReadingItem) {
//
//        RealmManager.sharedInstance.updateReadingItemFinishedState(object: item, isFinished: false)
//    }
//
//    func fetchFinishedItems() -> Results<ReadingItem>? {
//        return RealmManager.sharedInstance.readFinishedItems()
//    }
}
