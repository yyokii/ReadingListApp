//
//  FirestoreClientProtocol.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol FirestoreClientProtocol {
    
    /// リーディングリスト情報取得
    func fetchReadingList(completion: @escaping (Result<[ReadingListItem], AppError>) -> Void)
    
    /// アイテムを保存
    func addReadingItems(items: [[String: Any]], completion: @escaping (Result<[ReadingListItem], AppError>) -> Void)
    
    /// 任意のアイテムのステータスを未読に設定
    func changeStateToReading(docId: String, dueDate: Date, completion: @escaping (Result<Any?, AppError>) -> Void)
    
    /// 任意のアイテムのステータスを読み終わりに設定
    func changeStateToFinished(docId: String, completion: @escaping (Result<Any?, AppError>) -> Void)
    
    /// 任意のアイテムを論理削除
    func deleteReadingItems(docIds: [String], completion: @escaping (Result<Any?, AppError>) -> Void)
    
    /// ユーザー情報取得
    func fetchUser(completion: @escaping (AppUser) -> Void)
    
    /// 匿名ログイン
    func signSignInAnonymously(completion: @escaping (Result<AppUser, AppError>) -> Void)
    
    /// 匿名ユーザーから昇格させる（メールアドレスとパスワード）
    func convertToPermanent(email: String, pass: String, completion: @escaping (Result<AppUser, AppError>) -> Void)
    
    /// Emailログイン
    func signIn(email: String, pass: String, completion: @escaping (Result<AppUser, AppError>) -> Void)
    
    /// ログアウト（Emailログインしている場合）
    func signOut(completion: @escaping (AppError?) -> Void)
}
