//
//  ReadingListGatewayProtocol.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

protocol ReadingListGatewayProtocol {
    
    func saveItems(items: [[String: Any]], completion: @escaping (Result<Any?, WebClientError>) -> Void)
    
    /// リーディングリスト情報取得
    func fetchReadingListFromLocal() -> [[String: Any]]?
    
    /// リーディングリスト情報取得
    func fetchReadingList( completion: @escaping ([ReadingItem]) -> Void)
    
    /// ローカルに保存されているリーディングリスト情報をデータを削除
    func deleteLocalReadingListDatas()
}
