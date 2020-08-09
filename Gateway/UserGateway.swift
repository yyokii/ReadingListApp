//
//  UserGateway.swift
//  GateWay
//
//  Created by 東原与生 on 2020/06/29.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

protocol FirestoreClientProtocol {
    
    /// リーディングリスト情報取得
    func fetchReadingList(completion: @escaping () -> Void)
    
    /// アイテムを保存
    func addReadingItems(items: [[String: Any]], completion: @escaping (Result<Any?, WebClientError>) -> Void)
    
    /// 任意のアイテムを削除
    func deleteReadingItem()
    
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

final class UserGateway: UserGatewayProtocol {
    
    private weak var useCase: AuthUseCaseProtocol!
    var fireStoreClient: FirestoreClientProtocol!
    //    var dataStore: DataStoreProtocol!
    
    private var user: AppUser?
    
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func saveItems(items: [[String: Any]], completion: @escaping (Result<Any?, WebClientError>) -> Void) {
        
        fireStoreClient.addReadingItems(items: items) { res in
            
            switch res {
            case .success:
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
    
    func fetchReadingList( completion: @escaping ([ReadingItem]) -> Void) {
        fireStoreClient.fetchReadingList {
            //            completion()
        }
    }
    
    func fetchUser(completion: @escaping (AppUser) -> Void) {
        
        if let appUser = user {
            // キャッシュ
            completion(appUser)
        } else {
            fireStoreClient.fetchUser { user in
                self.user = user
                completion(user)
            }
        }
    }
    
    func signIn(with email: String, pass: String, completion: @escaping (Result<AppUser, WebClientError>) -> Void) {
    }
    
    func signSignInAnonymously(completion: @escaping (Result<AppUser, WebClientError>) -> Void) {
        
        fireStoreClient.signSignInAnonymously { [weak self] res in
            guard let self = self else {
                completion(.failure(.other(nil)))
                return
            }
            
            switch res {
            case .success(let appUser):
                self.user = appUser
                completion(.success(self.user!))
            case .failure(let error):
                completion(.failure(.serverError(error)))
            }
        }
    }
}
