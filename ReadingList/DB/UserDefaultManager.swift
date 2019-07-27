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
    
    /// リーディングリスト画面が起動済みかどうか
    func isFirstOpenReadingListView() -> Bool {
        sharedDefaults.register(defaults: [Constant.UserDefault.firstOpenReadingListView: true])
        return sharedDefaults.bool(forKey: Constant.UserDefault.firstOpenReadingListView)
    }
    
    /// リーディングリスト画面が起動済みであることを保存する
    func setFirstOpenReadingListView() {
        sharedDefaults.set(false, forKey: Constant.UserDefault.firstOpenReadingListView)
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
