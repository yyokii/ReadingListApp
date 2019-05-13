//
//  ReadingItem.swift
//  ReadingList
//
//  Created by Yoki Higashihara on 2019/04/21.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import RealmSwift

class ReadingItem: Object {
    @objc dynamic var url = ""
    @objc dynamic var title = ""
    @objc dynamic var imageUrl = ""
    // FIXME: これdateにカエルに当たって保存フローを修正したい
    // 記事がアプリに追加された日
    @objc dynamic var createdDate: Date?
    // いつまでに読み終わる予定か
    @objc dynamic var expirationDate: Date?
    // 読み終わった日（値がある＝読み終わっている、値なし＝まだ読み終わってない）
    @objc dynamic var finishedDate: Date?
}
