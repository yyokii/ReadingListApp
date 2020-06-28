//
//  AuthUseCase.swift
//  UseCase
//
//  Created by 東原与生 on 2020/06/28.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import GateWay

// Input
// Use Caseが外側に公開するインターフェイス
protocol AuthUseCaseProtocol: AnyObject {
    // 匿名ログイン
    func signSignInAnonymously()
    
    // ユーザー情報取得
    func fetchUser()
    
    // Emailログイン
    func signIn()
    
    // ログアウト（Emailログインしている場合）
    func signOut()
    
    var output: AuthUseCaseOutput! { get set }
}

// Output
protocol AuthUseCaseOutput {
    // 匿名ログイン完了
    func didsignSignInAnonymously()
    
    // ユーザー情報が更新されたときに呼ばれる
    func didUpdateUser(_ repoStatuses: Data)
    
    // Emailログイン完了
    func didsignIn(_ repoStatuses: Data)
        
    // Use Caseの関係する処理でエラーがあったときに呼ばれる
    func useCaseDidReceiveError(_ error: Error)
}
