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
    @objc dynamic var createdDate = ""
    @objc dynamic var finishedDate = ""
}
