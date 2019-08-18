//
//  HomeModel.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol HomeModelInput {
    func fetchFinishedListCount() -> Int
    func fetchFinishedGraphData() -> Array<Double>
    func fetchReadingListCount() -> Int
    func fetchTodayAddCount() -> Int
    func expire1DayCount() -> Int
    func expire2DaysCount() -> Int
}

final class HomeModel: HomeModelInput {
    func fetchFinishedGraphData() -> Array<Double> {
        var datas = Array<Double>()
        
        let now = Date()
        let res = RealmManager.sharedInstance.readItemsFinishedInAWeek(now: now)
        
        guard let result = res else { return datas }
        
        // 1週間のスタート日（この日から7日分をグラフで表示）
        let firstDate = Date(timeInterval: -60*60*24*7, since: now)
        
        for i in 0..<7 {
            let targetIndex = Double(i + 1)
            let targetDate = Date(timeInterval: 60*60*24*1*targetIndex, since: firstDate)
            print(targetDate)
            let startOfDay = targetDate.startOfDay
            let endOfDay = targetDate.endOfDay
            
            let counts = result.filter("finishedDate >= %@ && finishedDate <= %@ && isDeleted == false", startOfDay, endOfDay).count
            datas.append(Double(counts))
        }
        return datas
    }
    
    /// リーディングリスト総数を取得
    func fetchReadingListCount() -> Int {
        let count = RealmManager.sharedInstance.readNotFinishedItems()?.count
        guard let listCount = count else { return 0 }
        return listCount
    }
    
    /// 読み終わっている総数を取得
    func fetchFinishedListCount() -> Int {
        let count = RealmManager.sharedInstance.readFinishedItems()?.count
        guard let finishedCount = count else { return 0 }
        return finishedCount
    }

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
