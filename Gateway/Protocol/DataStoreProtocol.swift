//
//  DataStoreProtocol.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol DataStoreProtocol: AnyObject {
    
    // 起動回数確認
    
    /// 記事画面が起動済みかどうか
    func isFirstOpenArticleView() -> Bool
    /// 記事画面が起動済みであることを保存する
    func setFirstOpenArticleView()
    /// webViewが起動済みかどうか
    func isFirstOpenArticleWebView() -> Bool
    /// webViewが起動済みであることを保存する
    func setFirstOpenArticleWebView()
    
    // リーディングリスト情報の保存、取得、削除
    
    func addReadingItem(readingItem: [String: Any])
    func fetchReadingItems() -> [[String: Any]]?
    func deleteReadingItems()
}
