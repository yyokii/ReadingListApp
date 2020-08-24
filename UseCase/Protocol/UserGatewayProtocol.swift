//
//  UserGatewayProtocol.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

protocol UserGatewayProtocol {
    
    /// ユーザー情報取得
    func fetchUser(completion: @escaping (AppUser) -> Void)
    
    /// 匿名ユーザーから昇格させる（メールアドレスとパスワード）
    func convertToPermanent(email: String, pass: String, completion: @escaping (Result<AppUser, WebClientError>) -> Void)
    
    /// Emailログイン
    func signIn(email: String, pass: String, completion: @escaping (Result<AppUser, WebClientError>) -> Void)
    
    /// 匿名ログイン
    func signSignInAnonymously(completion: @escaping (Result<AppUser, WebClientError>) -> Void)
    
    /// ログアウト
    func signOut(completion: @escaping (WebClientError?) -> Void)
    
    var currentUser: AppUser? { get }
}
