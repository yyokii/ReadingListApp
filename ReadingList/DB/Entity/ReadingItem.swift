//
//  ReadingItem.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/21.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import RealmSwift

/// リーディングリストのアイテム（読む予定のもの or 読み終わりのもの）
class ReadingItem: Object {
    @objc dynamic var url = ""
    @objc dynamic var title = ""
    @objc dynamic var imageUrl = ""
    // 記事がアプリに追加された日
    @objc dynamic var createdDate: Date?
    // いつまでに読み終わる予定か
    @objc dynamic var dueDate: Date?
    // 読み終わった日（値がある＝読み終わっている、値なし＝まだ読み終わってない）
    @objc dynamic var finishedDate: Date?
}
