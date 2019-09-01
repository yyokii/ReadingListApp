//
//  HomeModel.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import Foundation

protocol HomeModelInput {
    func expireOneDayCount() -> Int
    func expireTwoDaysCount() -> Int
    func expireThreeDaysCount() -> Int
    func expireFourDaysCount() -> Int
    func expireFiveDaysCount() -> Int
    func expireSixDaysCount() -> Int
    func expireSevenDaysCount() -> Int
}

final class HomeModel: HomeModelInput {
    /// 期限日が1日以内のものの件数を返す
    func expireOneDayCount() -> Int {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 1) else { return 0 }
        return res.count
    }
    
    /// 期限日が1日より長く、2日以内のものの件数を返す
    func expireTwoDaysCount() -> Int {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 2) else { return 0 }
        return res.count
    }
    
    /// 期限日が2日より長く、3日以内のものの件数を返す
    func expireThreeDaysCount() -> Int {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 3) else { return 0 }
        return res.count
    }
    
    /// 期限日が3日より長く、4日以内のものの件数を返す
    func expireFourDaysCount() -> Int {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 4) else { return 0 }
        return res.count
    }
    
    /// 期限日が4日より長く、5日以内のものの件数を返す
    func expireFiveDaysCount() -> Int {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 5) else { return 0 }
        return res.count
    }
    
    /// 期限日が5日より長く、6日以内のものの件数を返す
    func expireSixDaysCount() -> Int {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 6) else { return 0 }
        return res.count
    }
    
    /// 期限日が6日より長く、7日以内のものの件数を返す
    func expireSevenDaysCount() -> Int {
        guard let res = RealmManager.sharedInstance.readItemsByDueDate(duedate: 7) else { return 0 }
        return res.count
    }
}
