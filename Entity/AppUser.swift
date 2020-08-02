//
//  AppUser.swift
//  Entity
//
//  Created by 東原与生 on 2020/06/29.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

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
