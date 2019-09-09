//
//  TodayDeleteModel.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/09/02.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation
import RealmSwift

protocol TodayDeleteModelInput {
    func fetchTodayDeleteItems() -> Results<ReadingItem>?
}

final class TodayDeleteModel: TodayDeleteModelInput {
    
    func fetchTodayDeleteItems() -> Results<ReadingItem>? {
        return RealmManager.sharedInstance.readTodayDeleteItems()
    }
}
