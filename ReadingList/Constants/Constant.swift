//
//  Constant.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/13.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

enum LocalNotificationType {
    // 1日前の通知
    case OneDayBefore
    // 2日前の通知
    case TwoDaysBefore
}

struct Constant {
    struct UserDefault {
        static let suiteName = "group.yyokii.ReadingList"
        static let readingItem = "readingItem"
        
        // 初回表示時されたかどうかを管理
        static let firstOpenArticleView = "firstOpenArticleView"
        static let firstOpenReadingListView = "firstOpenReadingListView"
    }
    
    struct ReadingItem {
        static let title = "title"
        static let url = "url"
        static let createdDate = "createdDate"
        static let dueDate = "dueDate"
        static let finishedDate = "finishedDate"
    }
    
    struct ViewTag {
        static let indicator = 1000
    }
    
    struct Color {
        // アセッツで定義している色
        static let sugarPlum = "SugarPlum"
        static let pinkSherbet = "PinkSherbet"
        static let bisque = "Bisque"
        static let caramel = "Caramel"
        static let greenSheen = "GreenSheen"
        static let myrtleGreen = "MyrtleGreen"
    }
    
    // ローカル通知
    struct LocalNotification {
        struct id {
            static let onwDayBefore = "onwDayBefore"
            static let twoDaysBefore = "twoDaysBefore"
        }
        
        // TODO: これ使っていないのでは？
        static let body = "あと2日でこちらの記事が自動的に削除されます👀\n"
    }
}
