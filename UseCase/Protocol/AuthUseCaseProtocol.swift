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
    
    // ユーザー情報取得（未設定の場合は匿名ログインを実施）
    func fetchUser()
    
    // ユーザー登録（匿名ユーザーを永久アカウントに昇格。メールアドレスとパスワード）
    func registerUser(mail: String, pass: String)
    
    // ログイン（Emailとパスワード）
    func signIn(mail: String, pass: String)
    
    // ログアウト（Emailログインしている場合）
    func signOut()
    
    // 現在のユーザー情報
    var currentUser: AppUser? { get }
    
    var output: AuthUseCaseOutput! { get set }
    var userGateway: UserGatewayProtocol! { get set }
}

// Output
protocol AuthUseCaseOutput {
    // ユーザー情報取得完了
    func didFetchUser()
    
    // Emailログイン完了
    func didsignIn()
    
    // 登録完了
    func didRegisterUser()
    
    // Use Caseの関係する処理でエラーがあったときに呼ばれる
    func useCaseDidReceiveError(error: AppError)
}
