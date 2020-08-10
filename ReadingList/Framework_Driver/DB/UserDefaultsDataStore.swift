//
//  UserDefaultsDataStore.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol UserDefaultsProtocol {
    func array(forKey defaultName: String) -> [Any]?
    func bool(forKey defaultName: String) -> Bool
    func removeObject(forKey defaultName: String)
    func register(defaults registrationDictionary: [String : Any])
    func set(_ value: Any?, forKey defaultName: String)

}
extension UserDefaults: UserDefaultsProtocol {}

final class UserDefaultsDataStore: DataStoreProtocol {
    
    let userDefaults: UserDefaultsProtocol

    init(userDefaults: UserDefaultsProtocol = UserDefaults(suiteName: Constant.UserDefault.suiteName)!) {
        self.userDefaults = userDefaults
    }
    
    func isFirstOpenArticleView() -> Bool {
        userDefaults.register(defaults: [Constant.UserDefault.firstOpenArticleView: true])
        return userDefaults.bool(forKey: Constant.UserDefault.firstOpenArticleView)
    }
    
    func setFirstOpenArticleView() {
        userDefaults.set(false, forKey: Constant.UserDefault.firstOpenArticleView)
    }
    
    func isFirstOpenArticleWebView() -> Bool {
        userDefaults.register(defaults: [Constant.UserDefault.firstOpenArticleWebView: true])
        return userDefaults.bool(forKey: Constant.UserDefault.firstOpenArticleWebView)
    }
    
    func setFirstOpenArticleWebView() {
        userDefaults.set(false, forKey: Constant.UserDefault.firstOpenArticleWebView)
    }
    
    func addReadingItem(readingItem: [String : Any]) {
        if var savedItems = fetchReadingItems() {
            // 保存済みアイテムあり
            savedItems.append(readingItem)
            userDefaults.set(savedItems, forKey: Constant.UserDefault.readingItem)
        } else {
            userDefaults.set([readingItem], forKey: Constant.UserDefault.readingItem)
        }
    }
    
    func fetchReadingItems() -> [[String : Any]]? {
        return userDefaults.array(forKey: Constant.UserDefault.readingItem) as? [[String: Any]]
    }
    
    func deleteReadingItems() {
        userDefaults.removeObject(forKey: Constant.UserDefault.readingItem)
    }
}
