//
//  ReadingListGatewayProtocol.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

protocol ReadingListGatewayProtocol {

    /// 任意のアイテムの読み終わりステータスを更新
    func changeFinishedState(id: String, isFinished: Bool, completion: @escaping (Result<Any?, WebClientError>) -> Void)
    
    /// 任意のアイテムを削除
    func deleteReadingItem(id: String, completion: @escaping (Result<Any?, WebClientError>) -> Void)
    
    func saveItems(items: [[String: Any]], completion: @escaping (Result<[ReadingListItem], WebClientError>) -> Void)
    
    /// リーディングリスト情報取得
    func fetchReadingListFromLocal() -> [[String: Any]]?
    
    /// リーディングリスト情報取得
    func fetchReadingList(completion: @escaping (Result<[ReadingListItem], WebClientError>) -> Void)
    
    /// ローカルに保存されているリーディングリスト情報をデータを削除
    func deleteLocalReadingListDatas()
}
