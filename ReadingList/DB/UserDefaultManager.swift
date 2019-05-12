//
//  UserDefaultManager.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/13.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

class UserDefaultManager {
    static let shareInstance = UserDefaultManager()
    var defaultsStandard = UserDefaults.standard
    var sharedDefaults = UserDefaults(suiteName: Constant.UserDefault.suiteName)!
    
    private init() {}
    
    /// 記事アイテムを追加
    func addReadingItem(readingItem: [String:String]) {
        if var savedItems = fetchReadingItems() {
            // 保存済みアイテムあり
            savedItems.append(readingItem)
            sharedDefaults.set(savedItems, forKey: Constant.UserDefault.readingItem)
        } else {
            sharedDefaults.set([readingItem], forKey: Constant.UserDefault.readingItem)
        }
    }
    
    /// 保存している記事情報を取得
    func fetchReadingItems() -> [[String:String]]? {
        return sharedDefaults.array(forKey: Constant.UserDefault.readingItem) as? [[String:String]]
    }
    
    /// 保存している記事情報を空にする = 削除
    func deleteReadingItems() {
        sharedDefaults.set([[String:String]](), forKey: Constant.UserDefault.readingItem)
    }
}
