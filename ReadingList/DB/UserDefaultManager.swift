//
//  UserDefaultManager.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/13.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

// TODO: これも消したい userdefaultsdatastoreに移行したい
class UserDefaultManager {
    static let shareInstance = UserDefaultManager()
    var sharedDefaults = UserDefaults(suiteName: Constant.UserDefault.suiteName)!
    
    private init() {}

    // MARK: 初回起動かどうかの確認用
    
    /// 記事画面が起動済みかどうか
    func isFirstOpenArticleView() -> Bool {
        sharedDefaults.register(defaults: [Constant.UserDefault.firstOpenArticleView: true])
        return sharedDefaults.bool(forKey: Constant.UserDefault.firstOpenArticleView)
    }
    
    /// 記事画面が起動済みであることを保存する
    func setFirstOpenArticleView() {
        sharedDefaults.set(false, forKey: Constant.UserDefault.firstOpenArticleView)
    }
    
    /// webViewが起動済みかどうか
    func isFirstOpenArticleWebView() -> Bool {
        sharedDefaults.register(defaults: [Constant.UserDefault.firstOpenArticleWebView: true])
        return sharedDefaults.bool(forKey: Constant.UserDefault.firstOpenArticleWebView)
    }
    
    /// webViewが起動済みであることを保存する
    func setFirstOpenArticleWebView() {
        sharedDefaults.set(false, forKey: Constant.UserDefault.firstOpenArticleWebView)
    }
    
    // MARK: 記事情報
    
    /// 記事アイテムを追加
    func addReadingItem(readingItem: [String: Any]) {
        if var savedItems = fetchReadingItems() {
            // 保存済みアイテムあり
            savedItems.append(readingItem)
            sharedDefaults.set(savedItems, forKey: Constant.UserDefault.readingItem)
        } else {
            sharedDefaults.set([readingItem], forKey: Constant.UserDefault.readingItem)
        }
    }
        
    /// 保存している記事情報を取得
    func fetchReadingItems() -> [[String: Any]]? {
        return sharedDefaults.array(forKey: Constant.UserDefault.readingItem) as? [[String: Any]]
    }
    
    /// 保存している記事情報を空にする = 削除
    func deleteReadingItems() {
        sharedDefaults.removeObject(forKey: Constant.UserDefault.readingItem)
    }
}
