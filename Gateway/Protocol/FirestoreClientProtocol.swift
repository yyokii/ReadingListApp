//
//  FirestoreClientProtocol.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

protocol FirestoreClientProtocol {
    
    /// リーディングリスト情報取得
    func fetchReadingList(completion: @escaping (Result<[ReadingListItem], WebClientError>) -> Void)
    
    /// アイテムを保存
    func addReadingItems(items: [[String: Any]], completion: @escaping (Result<[ReadingListItem], WebClientError>) -> Void)

    /// 任意のアイテムの読み終わりステータスを更新
    func changeFinishedState(docId: String, isFinished: Bool, completion: @escaping (Result<Any?, WebClientError>) -> Void)
    
    /// 任意のアイテムを論理削除
    func deleteReadingItem(docId: String, completion: @escaping (Result<Any?, WebClientError>) -> Void)
    
    /// ユーザー情報取得
    func fetchUser(completion: @escaping (AppUser) -> Void)
    
    /// 匿名ログイン
    func signSignInAnonymously(completion: @escaping (Result<AppUser, WebClientError>) -> Void)
    
    /// 匿名ユーザーから昇格させる（メールアドレスとパスワード）
    func convertToPermanent(email: String, pass: String, completion: @escaping (Result<AppUser, WebClientError>) -> Void)
    
    /// Emailログイン
    func signIn(email: String, pass: String, completion: @escaping (Result<AppUser, WebClientError>) -> Void)
    
    /// ログアウト（Emailログインしている場合）
    func signOut(completion: @escaping (Result<Bool, WebClientError>) -> Void)
}
