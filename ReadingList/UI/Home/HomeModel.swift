//
//  HomeModel.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol HomeModelInput {
    func fetchTodayAddCount() -> Int
    func expire1DayCount() -> Int
    func expire2DaysCount() -> Int
}

final class HomeModel: HomeModelInput {

    /// 今日追加されたアイテム件数を取得する
    func fetchTodayAddCount() -> Int {
        let res = RealmManager.sharedInstance.readItemsAddedOn(date: Date())
        if let result = res {
            return result.count
        } else {
            return 0
        }
    }
    
    /// 期限日が1日以内のものの件数を返す
    func expire1DayCount() -> Int {
        let res = RealmManager.sharedInstance.readItemsByDueDateOneDayAfter()
        if let result = res {
            return result.count
        } else {
            return 0
        }
    }
    
    /// 期限日が1日より長く、2日以内,のものの件数を返す
    func expire2DaysCount() -> Int {
        let res = RealmManager.sharedInstance.readItemsByDueDateTowDaysAfter()
        if let result = res {
            return result.count
        } else {
            return 0
        }
    }
}
