//
//  ReadingListModel.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/09/07.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol ReadingListModelInput {
    func fetchReadingItems() -> [ReadingListItem]
}

final class ReadingListModel: ReadingListModelInput {
    
    func fetchReadingItems() -> [ReadingListItem] {

        // TODO: fix
        return [ReadingListItem]()
    }
}
