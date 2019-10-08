//
//  DeletedListModel.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/10/07.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol DeletedListModelInput {
    func fetchDeletedItems() -> Results<ReadingItem>?
}

class DeletedListModel: DeletedListModelInput {
    
    func fetchDeletedItems() -> Results<ReadingItem>? {
        return RealmManager.sharedInstance.readDeletedItems()
    }
}
