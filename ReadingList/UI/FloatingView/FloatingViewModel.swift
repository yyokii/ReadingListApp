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
    func changeItemStateToReading(item: ReadingItem)
    func deleteItem(readingItem: ReadingItem)
    func fetchFinishedItems() -> Results<ReadingItem>?
}

final class FloatingViewModel: FloatingViewModelInput {

    /// 特定のアイテムを削除
    func deleteItem(readingItem: ReadingItem) {
        RealmManager.sharedInstance.deleteItem(title: readingItem.title, url: readingItem.url, createdDate: readingItem.createdDate!)
    }
    
    // アイテムをリーディングリストに戻す
    func changeItemStateToReading(item: ReadingItem) {
        
        RealmManager.sharedInstance.updateReadingItemFinishedState(object: item, isFinished: false)
    }
    
    func fetchFinishedItems() -> Results<ReadingItem>? {
        return RealmManager.sharedInstance.readFinishedItems()
    }
}
