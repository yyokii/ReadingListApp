//
//  AuthUseCaseProtocol.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/08/10.
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
