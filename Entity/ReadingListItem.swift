//
//  ReadingListItem.swift
//  ReadingList
//
//  Created by 東原与生 on 2020/07/04.
//  Copyright © 2020 Yoki Higashihara. All rights reserved.
//

import Foundation

/// リーディングリストのアイテム
struct ReadingListItem {
    let url: String
    let title: String
    let imageUrl: String
    /// 記事がDBに追加された日
    let createdDate: Date?
    /// いつまでに読み終わる予定か
    let dueDate: Date?
    /// 読み終わった日（値がある＝読み終わっている、値なし＝まだ読み終わってない）
    let finishedDate: Date?
    /// 削除フラグ
    let isDeleted = false
    
    /// 引数で与えられたdateと期限日との日数差（baseDate - dueDate）
    func differenceDay(fromDate: Date) -> Int {
        guard let dueDate = self.dueDate else { return 0 }
        let diff = fromDate.differenceInDay(dueDate)
        return diff
    }
}
