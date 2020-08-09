//
//  AppUser.swift
//  Entity
//
//  Created by 東原与生 on 2020/06/29.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import FirebaseAuth

struct AppUser {
    let id: String
    let name: String
    let status: UserStatus
}

enum UserStatus {
    // ユーザー情報が未作成
    case uninitialized
    // ログイン状態
    case authenticated
    // 匿名ログイン状態
    case authenticatedAnonymously
}

extension AppUser {
    init(from firebaseUser: User?) {
        
        if  firebaseUser == nil {
            // 未認証
            id = ""
            name = ""
            status = .uninitialized
        } else if firebaseUser!.isAnonymous {
            // 匿名ログイン
            id = firebaseUser!.uid
            name = ""
            status = .authenticatedAnonymously
        } else {
            // ログイン済
            id = firebaseUser!.uid
            name = ""
            status = .authenticatedAnonymously
        }
    }
}
