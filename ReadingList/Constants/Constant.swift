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
        static let shareUrl = "shareUrl"
        
        static let readingItem = "readingItem"
    }
    
    struct ReadingItem {
        static let title = "title"
        static let url = "url"
        static let createdDate = "createdDate"
        static let dueDate = "dueDate"
        static let finishedDate = "finishedDate"
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
