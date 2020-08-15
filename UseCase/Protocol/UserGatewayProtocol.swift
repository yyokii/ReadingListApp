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
    
    /// Emailログイン
    func signIn(with email: String, pass: String, completion: @escaping (Result<AppUser, WebClientError>) -> Void)
    
    /// 匿名ログイン
    func signSignInAnonymously(completion: @escaping (Result<AppUser, WebClientError>) -> Void)
}
