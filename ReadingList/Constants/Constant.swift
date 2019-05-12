//
//  Constant.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/13.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

struct Constant {
    struct UserDefault {
        static let suiteName = "group.yyokii.ReadingList"
        static let shareUrl = "shareUrl"
        
        static let readingItem = "readingItem"
    }
    
    struct readingItem {
        static let title = "title"
        static let url = "url"
        static let createdDate = "createdDate"
        static let finishedDate = "finishedDate"
    }
}
