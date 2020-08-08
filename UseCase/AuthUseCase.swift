//
//  AuthUseCase.swift
//  UseCase
//
//  Created by 東原与生 on 2020/06/28.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

// Input
// Use Caseが外側に公開するインターフェイス
protocol AuthUseCaseProtocol: AnyObject {
    // ユーザー情報取得
    func fetchUser()
    
    // Emailログイン
    func signIn()
    
    // ログアウト（Emailログインしている場合）
    func signOut()
    
    var output: AuthUseCaseOutput! { get set }
    var userGateway: UserGatewayProtocol! { get set }
}

// Output
protocol AuthUseCaseOutput {
    // ユーザー情報取得完了
    func didFetchUser()
    
    // Emailログイン完了
    func didsignIn(_ repoStatuses: String)
    
    // Use Caseの関係する処理でエラーがあったときに呼ばれる
    func useCaseDidReceiveError(_ error: WebClientError)
}


protocol UserGatewayProtocol {
    /// リーディングリスト情報取得
    func fetchReadingList( completion: @escaping ([ReadingItem]) -> Void)
    
    /// ユーザー情報取得
    func fetchUser(completion: @escaping (AppUser) -> Void)
    
    /// Emailログイン
    func signIn(with email: String, pass: String, completion: @escaping (Result<AppUser, WebClientError>) -> Void)
    
    /// 匿名ログイン
    func signSignInAnonymously(completion: @escaping (Result<AppUser, WebClientError>) -> Void)
}

final class AuthUseCase: AuthUseCaseProtocol {
    var userGateway: UserGatewayProtocol!
    var output: AuthUseCaseOutput!
    
    func fetchUser() {
        userGateway.fetchUser {[weak self] user in
            
            guard let self = self else { return }
            
            switch user.status {
            case .uninitialized:
                self.userGateway.signSignInAnonymously { (res) in
                    switch res {
                    case .success(let appUser):
                        self.output.didFetchUser()
                        break
                    case .failure(let error):
                        self.output.useCaseDidReceiveError(error)
                        break
                    }
                }
            case .authenticatedAnonymously:
                self.output.didFetchUser()
                break
            case .authenticated:
                self.output.didFetchUser()
                break
            }
        }
    }
    
    func signIn() {
    }
    
    func signOut() {
        
    }
}
