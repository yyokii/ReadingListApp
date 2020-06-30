//
//  FirestoreClient.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/06/28.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import FirebaseAuth

protocol FirestoreClientProtocol {
    
    /// リーディングリスト情報取得
    func fetchReadingList( completion: @escaping () -> Void)
    
    /// 任意のアイテムを削除
    func deleteReadingItem()
    
    /// 匿名ログイン
    func signSignInAnonymously(completion: @escaping (Result<User, WebClientError>) -> Void)
    
    /// 匿名ユーザーから昇格させる（メールアドレスとパスワード）
    func convertToPermanent(user: User, email: String, pass: String, completion: @escaping (Result<User, WebClientError>) -> Void)
    
    /// Emailログイン
    func signIn(email: String, pass: String, completion: @escaping (Result<User, WebClientError>) -> Void)
    
    /// ログアウト（Emailログインしている場合）
    func signOut(completion: @escaping (Result<Bool, WebClientError>) -> Void)
}

final class FireStoreClient: FirestoreClientProtocol {
    
    func fetchReadingList( completion: @escaping () -> Void) {
    }
    
    func deleteReadingItem() {
    }
    
    func signSignInAnonymously(completion: @escaping (Result<User, WebClientError>) -> Void) {

        Auth.auth().signInAnonymously() { (authResult, error) in
            
            if let error = error {
                completion(.failure(.serverError(error)))
            } else {
                guard let user = authResult?.user else {
                    completion(.failure(.other(nil)))
                    return
                }
                completion(.success(user))
            }
        }
    }
    
    func convertToPermanent(user: User, email: String, pass: String, completion: @escaping (Result<User, WebClientError>) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: pass)
        
        user.link(with: credential) { (authResult, error) in
            
           if let error = error {
                completion(.failure(.serverError(error)))
            } else {
                guard let user = authResult?.user else {
                    completion(.failure(.other(nil)))
                    return
                }
                completion(.success(user))
            }
        }
    }
    
    func signIn(email: String, pass: String, completion: @escaping (Result<User, WebClientError>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
            
            if let error = error {
                completion(.failure(.serverError(error)))
            } else {
                guard let user = authResult?.user else {
                    completion(.failure(.other(nil)))
                    return
                }
                completion(.success(user))
            }
        }
    }
    
    // ログアウト（Emailログインしている場合）
    func signOut(completion: @escaping (Result<Bool, WebClientError>) -> Void) {

        do {
            try Auth.auth().signOut()
            completion(.success(true))
        } catch let signOutError as NSError {
            print ("エラー サインアウト: %@", signOutError)
            completion(.failure(.serverError(signOutError)))
        }
    }
}
