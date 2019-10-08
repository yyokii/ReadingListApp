//
//  ArticleWebModel.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/07/06.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol ArticleWebModelInput {
    func addItemToReadingList(item: ReadingItem)
    func addItemToFinishedList(item: ReadingItem)
}

final class ArticleWebModel: ArticleWebModelInput {
    
    /// リーディングリストに保存する
    func addItemToReadingList(item: ReadingItem) {
        
        RealmManager.sharedInstance.updateReadingItemFinishedState(object: item, isFinished: false)
    }
    
    /// 読み終わりアイテムに保存する
    func addItemToFinishedList(item: ReadingItem) {
        RealmManager.sharedInstance.updateReadingItemFinishedState(object: item, isFinished: true)
    }
}

