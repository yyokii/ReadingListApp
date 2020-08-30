//
//  ReadingListGatewayProtocol.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol ReadingListGatewayProtocol {
    
    /// 任意のアイテムのステータスを未読に設定
    func changeStateToReading(id: String, dueDate: Date, completion: @escaping (Result<Any?, AppError>) -> Void)
    
    /// 任意のアイテムのステータスを読み終わりに設定
    func changeStateToFinished(id: String, completion: @escaping (Result<Any?, AppError>) -> Void)
    
    /// 任意のアイテムを削除
    func deleteReadingItems(ids: [String], completion: @escaping (Result<Any?, AppError>) -> Void)
    
    func saveItems(items: [[String: Any]], completion: @escaping (Result<[ReadingListItem], AppError>) -> Void)
    
    /// リーディングリスト情報取得
    func fetchReadingListFromLocal() -> [[String: Any]]?
    
    /// リーディングリスト情報取得
    func fetchReadingList(completion: @escaping (Result<[ReadingListItem], AppError>) -> Void)
    
    /// ローカルに保存されているリーディングリスト情報をデータを削除
    func deleteLocalReadingListDatas()
}
